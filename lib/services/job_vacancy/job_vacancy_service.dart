import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/job_vacancy/job_vacancy_response_model.dart';
import '../../models/job_vacancy/job_vacancy_detail_model.dart';

class JobVacancyService {
  final Dio _dio;

  JobVacancyService(this._dio);

  /// List semua lowongan kerja
  Future<JobVacancyResponse> getJobVacancies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.jobVacancy,
        queryParameters: {'page': page},
      );

      return JobVacancyResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil data lowongan kerja';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil data lowongan kerja';
    }
  }

  /// Detail lowongan kerja
  Future<JobVacancyDetail> getJobVacancyDetail(int id) async {
    try {
      final response = await _dio.get(ApiConfig.jobVacancyDetail(id));

      if (response.data == null || response.data['data'] == null) {
        throw 'Data detail lowongan tidak ditemukan';
      }

      return JobVacancyDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil detail lowongan kerja';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil detail lowongan kerja';
    }
  }

  /// Lowongan milik sendiri
  Future<JobVacancyResponse> getMyJobVacancies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.myJobVacancy,
        queryParameters: {'page': page},
      );

      return JobVacancyResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error ?? 'Gagal mengambil data lowongan Anda';
    } catch (e) {
      throw 'Terjadi kesalahan saat mengambil data lowongan Anda';
    }
  }

  /// Tambah lowongan kerja
  Future<void> createJobVacancy({
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

    await _dio.post(ApiConfig.jobVacancy, data: formData);
  }

  /// Update lowongan kerja
  Future<String> updateJobVacancy({
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
        ApiConfig.jobVacancyDetail(id),
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
