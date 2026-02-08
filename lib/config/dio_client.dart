import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/dio_error_handler.dart';
import 'api_config.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??=
        Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Accept': 'application/json'},
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');

                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                }

                handler.next(options);
              },
              onError: (DioException e, handler) {
                final message = DioErrorHandler.handle(e);
                handler.reject(
                  DioException(
                    requestOptions: e.requestOptions,
                    error: message,
                    response: e.response,
                    type: e.type,
                  ),
                );
              },
            ),
          );

    return _dio!;
  }
}
