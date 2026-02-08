import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/dio_client.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  /// GET /mobile/register-meta
  Future<Map<String, dynamic>> registerMeta() async {
    final response = await _dio.get(ApiConfig.registerMeta);
    return response.data;
  }

  /// POST /mobile/register
  Future<void> register(Map<String, dynamic> data) async {
    await _dio.post(ApiConfig.register, data: data);
  }

  /// POST /mobile/login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );

    final auth = AuthResponseModel.fromJson(response.data);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', auth.token);

    return auth;
  }

  /// POST /mobile/logout
  Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.logout);
    } catch (_) {
      // abaikan error API
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
