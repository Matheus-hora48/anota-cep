import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class RestClient extends DioForNative {
  RestClient()
      : super(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 20),
        )) {
    interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }
}
