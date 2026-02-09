import 'dart:io';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../config/dio_client.dart';
import '../models/profile_response_model.dart';

class ProfileService {
  /// GET /mobile/profile
  Future<ProfileResponse> fetchProfile() async {
    final response = await DioClient.instance.get(ApiConfig.profile);
    return ProfileResponse.fromJson(response.data);
  }

  /// POST /mobile/profile (create)
  Future<void> createProfile({
    String? phone,
    String? testimonial,
    String? bio,
    String? education,
    String? skills,
    String? experience,
    String? linkedinUrl,
    File? image,
    File? cvFile,
  }) async {
    final formData = FormData.fromMap({
      'phone': phone,
      'testimonial': testimonial,
      'bio': bio,
      'education': education,
      'skills': skills,
      'experience': experience,
      'linkedin_url': linkedinUrl,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
      if (cvFile != null) 'cv_file': await MultipartFile.fromFile(cvFile.path),
    });

    await DioClient.instance.post(ApiConfig.profile, data: formData);
  }

  /// PUT /mobile/profile (update)
  Future<void> updateProfile({
    String? phone,
    String? testimonial,
    String? bio,
    String? education,
    String? skills,
    String? experience,
    String? linkedinUrl,
    File? image,
    File? cvFile,
  }) async {
    final formData = FormData.fromMap({
      'phone': phone,
      'testimonial': testimonial,
      'bio': bio,
      'education': education,
      'skills': skills,
      'experience': experience,
      'linkedin_url': linkedinUrl,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
      if (cvFile != null) 'cv_file': await MultipartFile.fromFile(cvFile.path),
    });

    await DioClient.instance.put(ApiConfig.profile, data: formData);
  }
}
