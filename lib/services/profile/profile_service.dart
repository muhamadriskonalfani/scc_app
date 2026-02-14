import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../config/dio_client.dart';
import '../../models/profile/profile_response_model.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  /// GET /mobile/profile
  Future<ProfileResponse> getProfile() async {
    try {
      final response = await _dio.get(ApiConfig.profile);

      final profileResponse = ProfileResponse.fromJson(response.data);

      // if (!profileResponse.success) {
      //   throw Exception('Profile belum dibuat');
      // }

      return profileResponse;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Gagal mengambil data profile');
    }
  }

  /// POST /mobile/profile
  Future<void> createProfile({
    File? image,
    File? cvFile,
    File? alumniTag,
    String? phone,
    String? domicile,
    String? testimonial,
    String? bio,
    String? education,
    String? skills,
    String? experience,
    String? linkedinUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (phone != null) 'phone': phone,
        if (domicile != null) 'domicile': domicile,
        if (testimonial != null) 'testimonial': testimonial,
        if (bio != null) 'bio': bio,
        if (education != null) 'education': education,
        if (skills != null) 'skills': skills,
        if (experience != null) 'experience': experience,
        if (linkedinUrl != null) 'linkedin_url': linkedinUrl,

        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),

        if (cvFile != null)
          'cv_file': await MultipartFile.fromFile(
            cvFile.path,
            filename: cvFile.path.split('/').last,
          ),

        if (alumniTag != null)
          'alumni_tag': await MultipartFile.fromFile(
            alumniTag.path,
            filename: alumniTag.path.split('/').last,
          ),
      });

      await _dio.post(
        ApiConfig.profile,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      // Profile sudah ada
      if (e.response?.statusCode == 409) {
        throw Exception('Profile sudah ada');
      }

      // Validasi Laravel (422)
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message'] ?? 'Data tidak valid');
      }

      // Error dari backend
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat profile');
    } catch (e) {
      // Error lain (file, parsing, dll)
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// PUT /mobile/profile
  /// UPDATE /mobile/profile
  Future<void> updateProfile({
    File? image,
    File? cvFile,
    File? alumniTag,
    String? phone,
    String? domicile,
    String? testimonial,
    String? bio,
    String? education,
    String? skills,
    String? experience,
    String? linkedinUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (phone != null) 'phone': phone,
        if (domicile != null) 'domicile': domicile,
        if (testimonial != null) 'testimonial': testimonial,
        if (bio != null) 'bio': bio,
        if (education != null) 'education': education,
        if (skills != null) 'skills': skills,
        if (experience != null) 'experience': experience,
        if (linkedinUrl != null) 'linkedin_url': linkedinUrl,

        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),

        if (cvFile != null)
          'cv_file': await MultipartFile.fromFile(
            cvFile.path,
            filename: cvFile.path.split('/').last,
          ),

        if (alumniTag != null)
          'alumni_tag': await MultipartFile.fromFile(
            alumniTag.path,
            filename: alumniTag.path.split('/').last,
          ),
      });

      await _dio.post(
        ApiConfig.profile,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'X-HTTP-Method-Override': 'PUT', // untuk Laravel
          },
        ),
      );
    } on DioException catch (e) {
      // Profile belum ada (404)
      if (e.response?.statusCode == 404) {
        throw Exception('Profile belum dibuat');
      }

      // Validasi Laravel (422)
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message'] ?? 'Data tidak valid');
      }

      // Error dari backend
      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui profile',
      );
    } catch (e) {
      // Error lain (file, parsing, dll)
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
