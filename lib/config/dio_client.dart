import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import '../utils/dio_error_handler.dart';
import 'api_config.dart';

class DioClient {
  static Dio? _dio;

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
                // Laravel Sanctum token
                final token = await _storage.read(key: 'token');

                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }

                // Firebase App Check token
                try {
                  final appCheckToken = await FirebaseAppCheck.instance
                      .getToken();

                  if (appCheckToken != null && appCheckToken.isNotEmpty) {
                    options.headers['X-Firebase-AppCheck'] = appCheckToken;

                    // Testing
                    // debugPrint('App Check header berhasil ditambahkan');
                  }
                } catch (e) {
                  debugPrint('App Check Error: $e');
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
