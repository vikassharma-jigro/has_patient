import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:hms_patient/app_helpers/routes/app_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'app_url.dart';
import 'token_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage();

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _attachInterceptors();
  }

  // ── Interceptors ─────────────────────────────
  void _attachInterceptors() {
    _dio.interceptors.addAll([
      _authInterceptor(),
      _retryInterceptor(),
      if (kDebugMode) _logger(),
    ]);
  }

  // ── Auth Interceptor ─────────────────────────
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Proactive Refresh: Check before sending request
        if (_tokenStorage.hasToken && _tokenStorage.isTokenExpired) {
          debugPrint('DioClient: Token near expiry, triggering proactive refresh...');
          await _runRefresh();
        }

        final token = await _tokenStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onError: (err, handler) async {
        // 2. Reactive Refresh: Handle 401 Unauthorized
        if (err.response?.statusCode == 401) {
          debugPrint('401 Unauthorized detected at: ${err.requestOptions.path}');
          
          if (_tokenStorage.hasRefreshToken) {
            debugPrint('Attempting reactive refresh...');
            final refreshed = await _runRefresh();

            if (refreshed) {
              try {
                final newToken = await _tokenStorage.getAccessToken();
                final retryOptions = err.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newToken';

                debugPrint('Retrying original request with new token...');
                final response = await _dio.fetch(retryOptions);
                return handler.resolve(response);
              } catch (e) {
                debugPrint('Retry after refresh failed: $e');
              }
            }
          }

          // If we reach here, either no refresh token or refresh failed
          debugPrint('Session expired or refresh failed. Logging out...');
          await _tokenStorage.logout();
          
          if (AppRouter.navigatorKey.currentContext != null) {
             AppRouter.router.go('/login');
          }
        }
        handler.next(err);
      },
    );
  }

  // ── Refresh Token ────────────────────────────
  Future<bool> _runRefresh() {
    return _tokenStorage.refreshAccessToken((refreshToken) async {
      try {
        debugPrint('--- Refreshing Token ---');
        final plainDio = Dio(BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $refreshToken'
          },
        ));

        debugPrint('POST ${ApiUrls.refreshTokenEndpoint} with token: $refreshToken');

        final response = await plainDio.post(
          ApiUrls.refreshTokenEndpoint,
          data: {},
        );

        debugPrint('Refresh Response [${response.statusCode}]: ${response.data}');

        if (response.statusCode == 200 && response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final data = responseData['data'] is Map 
              ? responseData['data'] as Map<String, dynamic> 
              : responseData;

          final newAccess = data['accessToken']?.toString();
          final newRefresh = data['refreshToken']?.toString();

          if (newAccess != null && newAccess.isNotEmpty) {
            debugPrint('New Tokens Received Successfully.');
            return {
              'accessToken': newAccess,
              'refreshToken': newRefresh ?? refreshToken, // Use old one if new not returned
            };
          }
        }
        debugPrint('Token refresh failed: Invalid response format');
        return null;
      } catch (e) {
        if (e is DioException) {
          debugPrint('Refresh Request Failed: ${e.response?.statusCode} - ${e.response?.data}');
        } else {
          debugPrint('Refresh Error: $e');
        }
        return null;
      }
    });
  }

  // ── Retry ───────────────────────────────────
  RetryInterceptor _retryInterceptor() => RetryInterceptor(
    dio: _dio,
    retries: 3,
    retryDelays: const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
    retryEvaluator: (error, attempt) =>
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionTimeout,
  );

  // ── Logger ──────────────────────────────────
  PrettyDioLogger _logger() => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    error: true,
    compact: true,
  );

  // ── HTTP Methods ────────────────────────────
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.patch<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.delete<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
    Options? options,
  }) => _dio.post<T>(
    path,
    data: formData,
    onSendProgress: onSendProgress,
    options: options,
  );
}
