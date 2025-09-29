import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://reqres.in/api/", // 👈 Global Base URL
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "x-api-key": "reqres-free-v1"
        },
      ),
    );

    // Optional logging & error interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ [${options.method}] ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (e, handler) {
          print("❌ DioError: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }
}
