import 'package:dio/dio.dart';
import 'package:hms_patient/app_helpers/network/app_url.dart';
import 'api_client.dart';
import 'api_error.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiFailure<T> extends ApiResult<T> {
  final ApiError error;
  const ApiFailure(this.error);
}

class ApiBaseHelper {
  static final ApiBaseHelper _instance = ApiBaseHelper._internal();
  factory ApiBaseHelper() => _instance;
  final DioClient _api = DioClient();
  ApiBaseHelper._internal();
  Future<ApiResult<Map<String, dynamic>>> _execute(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      final bool isStatusCodeSuccess =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
      if (data is Map<String, dynamic>) {
        if (data['success'] == false || !isStatusCodeSuccess) {
          return ApiFailure(
            ApiError(
              type: _typeFromStatus(response.statusCode),
              message:
                  data['message']?.toString() ??
                  data['error']?.toString() ??
                  'Request failed.',
              statusCode: response.statusCode,
              raw: data,
            ),
          );
        }
        return ApiSuccess(data);
      }

      if (!isStatusCodeSuccess) {
        return ApiFailure(
          ApiError(
            type: _typeFromStatus(response.statusCode),
            message: 'Server returned error status: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }

      return ApiFailure(ApiError.parse(data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
    } catch (e) {
      return ApiFailure(
        ApiError(type: ApiErrorType.unknown, message: e.toString()),
      );
    }
  }

  // ───────────────────────────────────────────
  ApiError _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const ApiError.network();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ApiError.timeout();
      case DioExceptionType.cancel:
        return const ApiError.cancelled();
      default:
        break;
    }

    final statusCode = e.response?.statusCode;
    final body = e.response?.data;
    final serverMessage = (body is Map) ? body['message']?.toString() : null;

    return ApiError(
      type: _typeFromStatus(statusCode),
      message: serverMessage ?? e.message ?? 'Something went wrong',
      statusCode: statusCode,
      raw: body,
    );
  }

  ApiErrorType _typeFromStatus(int? status) => switch (status) {
    400 => ApiErrorType.validation,
    401 => ApiErrorType.unauthorized,
    403 => ApiErrorType.forbidden,
    404 => ApiErrorType.notFound,
    _ => ApiErrorType.unknown,
  };

  // ───────────────────────────────────────────
  // 🔐 AUTH APIs
  // ───────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> login({
    required String userId,
    required String password,
  }) => _execute(
    () => _api.post(
      ApiUrls.login,
      data: {'identifier': userId, 'password': password ,'device': 'mob'},
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> registerApi({
    required String firstName,
    required String gender,
    required String lastName,
    required String emailAddress,
    required String dob,
    required String age,
    required String mobile,
    required String address,
    required String pincode,
    required String state,
    required String city,
  }) => _execute(
    () => _api.post(
      ApiUrls.register,
      data: {
        'firstName': firstName,
        'lastName': lastName ,'gender': gender,
        'dob': dob ,'age': age,
        'mobile': mobile ,'email': emailAddress,
        'address': address ,'state': state,
        'city': city ,'pincode': pincode,

      },
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> register1Api({
    required String IDProofNumber,
    required String IDProofType,
    String? insuranceNumber,
    required String allergy,
    required String infection,
    String? insuranceSchemeName,
    required String insuranceType,
    required String id,
    required List<String> seriousDiseases,
  }) => _execute(
    () => _api.patch(
      "${ApiUrls.register1}$id",
      data: _clean({
        'IDProofNumber': IDProofNumber,
        'IDProofType': IDProofType,
        'insuranceNumber': insuranceNumber,
        'allergy': allergy,
        'infection': infection,
        'insuranceSchemeName': insuranceSchemeName,
        'insuranceType': insuranceType,
        'seriousDiseases': seriousDiseases,
      }),
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> logout() =>
      _execute(() => _api.post(ApiUrls.logout));

  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String identifier,
  }) => _execute(
    () => _api.post(ApiUrls.forgotPassword, data: {'identifier': identifier}),
  );

  Future<ApiResult<Map<String, dynamic>>> setPassword({
    required String token,
    required String password,
  }) => _execute(
    () => _api.post(
      ApiUrls.setPassword,
      data: {'token': token, 'password': password},
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> getMe() =>
      _execute(() => _api.get(ApiUrls.me));

  Future<ApiResult<Map<String, dynamic>>> addPatient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dob,
    required String mobile,
    String? email,
    String? patientType,
    String? bloodGroup,
    String? occupation,
  }) => _execute(
    () => _api.post(
      ApiUrls.patients,
      data: _clean({
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'dob': dob,
        'mobile': mobile,
        'email': email,
        'patientType': patientType,
        'bloodGroup': bloodGroup,
        'occupation': occupation,
      }),
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> getPatients({
    Map<String, dynamic>? queryParameters,
  }) => _execute(
    () => _api.get(ApiUrls.patients, queryParameters: queryParameters),
  );

  Future<ApiResult<Map<String, dynamic>>> getPatientById(String id) =>
      _execute(() => _api.get(ApiUrls.patientById(id)));

  Future<ApiResult<Map<String, dynamic>>> updateBasicDetails({
    required String patientId,
    String? firstName,
    String? lastName,
    String? gender,
    String? dob,
    String? mobile,
    String? email,
    String? bloodGroup,
    String? occupation,
  }) => _execute(
    () => _api.patch(
      ApiUrls.patientById(patientId),
      data: _clean({
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'dob': dob,
        'mobile': mobile,
        'email': email,
        'bloodGroup': bloodGroup,
        'occupation': occupation,
      }),
    ),
  );
  Future<ApiResult<Map<String, dynamic>>> getMyBookings({
    Map<String, dynamic>? queryParameters,
  }) => _execute(
    () => _api.get(
      ApiUrls.patientBookings,
      queryParameters: {
        'page': queryParameters?['page'] ?? 1,
        'limit': queryParameters?['limit'] ?? 10,
        'search': queryParameters?['search'] ?? '',
      },
    ),
  );
  Future<ApiResult<Map<String, dynamic>>> getInvoices({
    Map<String, dynamic>? queryParameters,
  }) => _execute(
    () => _api.get(
      ApiUrls.paitentInvoice,
      queryParameters: {
        'page': queryParameters?['page'] ?? 1,
        'limit': queryParameters?['limit'] ?? 10,
        'search': queryParameters?['search'] ?? '',
      },
    ),
  );
  Future<ApiResult<Map<String, dynamic>>> getLabReports({
    Map<String, dynamic>? queryParameters,
  }) => _execute(
    () => _api.get(
      ApiUrls.labReports,
      queryParameters: {
        'page': queryParameters?['page'] ?? 1,
        'limit': queryParameters?['limit'] ?? 10,
        'type': queryParameters?['type'] ?? 'lab',
      },
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> getPatientDashboard() =>
      _execute(() => _api.get(ApiUrls.patientDashboard));

  Future<ApiResult<Map<String, dynamic>>> getBookingDoctors({
    Map<String, dynamic>? queryParameters,
  }) => _execute(() => _api.get(ApiUrls.bookingDoctors, queryParameters: {
    'page': queryParameters?['page'] ?? 1,
    'limit': queryParameters?['limit'] ?? 10,
    'search': queryParameters?['search'] ?? '',
  }));

  Future<ApiResult<Map<String, dynamic>>> getDoctorAvailability(String doctorId) =>
      _execute(() => _api.get('${ApiUrls.bookingDoctors}/$doctorId'));

  Future<ApiResult<Map<String, dynamic>>> createAppointment({
    required String doctor,
    required String time,
    required String bookingType,
    required String consultantMode,
    required String department,
    required int doctorFee,
    required String opdDate,
  }) => _execute(
    () => _api.post(
      ApiUrls.bookingDoctors,
      data: {
        'doctor': doctor,
        'time': time,
        'bookingType': bookingType,
        'consultantMode': consultantMode,
        'department': department,
        'doctorFee': doctorFee,
        'opdDate': opdDate,
      },
    ),
  );

  Future<ApiResult<Map<String, dynamic>>> uploadDocument({
    required String documentName,
    required String filePath,
  }) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'documentName': documentName,
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    return _execute(() => _api.post(ApiUrls.uploadDocument, data: formData));
  }

  Future<ApiResult<Map<String, dynamic>>> deletePatient(String id) =>
      _execute(() => _api.delete(ApiUrls.patientById(id)));

  Map<String, dynamic> _clean(Map<String, dynamic> data) {
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
