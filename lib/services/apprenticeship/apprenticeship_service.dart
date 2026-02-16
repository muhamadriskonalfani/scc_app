import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/apprenticeship/apprenticeship_response_model.dart';
import '../../models/apprenticeship/apprenticeship_detail_model.dart';

class ApprenticeshipService {
  final Dio _dio;

  ApprenticeshipService(this._dio);

  /// List semua magang (student & alumni)
  Future<ApprenticeshipResponse> getApprenticeships({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.apprenticeship,
        queryParameters: {'page': page},
      );

      return ApprenticeshipResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil data magang';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil data magang';
    }
  }

  /// Detail magang
  Future<ApprenticeshipDetail> getApprenticeshipDetail(int id) async {
    try {
      final response = await _dio.get(ApiConfig.apprenticeshipDetail(id));

      if (response.data == null || response.data['data'] == null) {
        throw 'Data detail magang tidak ditemukan';
      }

      return ApprenticeshipDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil detail magang';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil detail magang';
    }
  }

  /// Alumni: magang milik sendiri
  Future<ApprenticeshipResponse> getMyApprenticeships({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.myApprenticeship,
        queryParameters: {'page': page},
      );

      return ApprenticeshipResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil data magang Anda';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil data magang Anda';
    }
  }

  /// Tambah Info Magang
  Future<void> createApprenticeship({
    required String title,
    required String description,
    required String companyName,
    required String location,
    required String applicationLink,
    String? expiredAt,
    File? image,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'company_name': companyName,
      'location': location,
      'application_link': applicationLink,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });

    await _dio.post(ApiConfig.apprenticeship, data: formData);
  }

  /// Update Info Magang
  Future<String> updateApprenticeship({
    required int id,
    required Map<String, dynamic> data,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',
        ...data,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post(
        ApiConfig.apprenticeshipDetail(id),
        data: formData,
      );

      return response.data['message'] ?? 'Berhasil update';
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal');
      }
      throw Exception('Terjadi kesalahan server');
    }
  }
}
