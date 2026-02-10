import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/dio_client.dart';
import '../models/profile_response_model.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  /// GET /mobile/profile
  Future<ProfileResponse> getProfile() async {
    final response = await _dio.get(ApiConfig.profile);
    return ProfileResponse.fromJson(response.data);
  }

  /// POST /mobile/profile (create)
  Future<void> createProfile({
    Map<String, dynamic>? data,
    String? imagePath,
    String? cvPath,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      if (cvPath != null) 'cv_file': await MultipartFile.fromFile(cvPath),
    });

    await _dio.post(
      ApiConfig.profile,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  /// PUT /mobile/profile (update)
  Future<void> updateProfile({
    Map<String, dynamic>? data,
    String? imagePath,
    String? cvPath,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      if (cvPath != null) 'cv_file': await MultipartFile.fromFile(cvPath),
    });

    await _dio.put(
      ApiConfig.profile,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
