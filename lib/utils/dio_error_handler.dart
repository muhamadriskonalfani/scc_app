import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handle(DioException e) {
    // Timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi timeout. Coba lagi.';
    }

    // Tidak ada koneksi
    if (e.type == DioExceptionType.connectionError) {
      return 'Tidak ada koneksi internet.';
    }

    // Response dari backend
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'];
      }

      return 'Terjadi kesalahan (${e.response?.statusCode})';
    }

    return 'Terjadi kesalahan tak terduga';
  }
}
