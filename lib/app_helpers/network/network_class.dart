import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;
  //final LocalStorage storage;

  DioClient(/*this.storage*/)
    : dio = Dio(
        BaseOptions(
          baseUrl: "http://priyaapi.zenovaservices.com",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json"},
        ),
      ) {
    dio.interceptors.addAll([
      InterceptorsWrapper(
        /// REQUEST
        onRequest: (options, handler) {
          // final token = sp?.getString(SpUtil.ACCESS_TOKEN);
          // Logger().i("Token Get : $token");

          // if (token != null && token.isNotEmpty) {
          //   options.headers["Authorization"] = "Bearer $token";
          // }

          // print("🚀 REQUEST[${options.method}] => PATH: ${options.path}");
          // print("Headers: ${options.headers}");
          // print("Body: ${options.data}");
          // print("Query: ${options.queryParameters}");

          return handler.next(options);
        },

        /// 🔥 RESPONSE
        onResponse: (response, handler) {
          // print(
          //   "✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}",
          // );
          // print("Data: ${response.data}");

          return handler.next(response);
        },

        /// 🔥 ERROR
        onError: (error, handler) {
          // print(
          //   "❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}",
          // );
          // print("Message: ${error.message}");

          return handler.next(error);
        },
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
        enabled: true,
        request: true,
        error: true,
      ),
    ]);
  }
}
