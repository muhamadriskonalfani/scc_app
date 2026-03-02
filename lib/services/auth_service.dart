import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../config/dio_client.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  /// Secure storage untuk token
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// ===============================
  /// GET /mobile/register-meta
  /// ===============================
  Future<Map<String, dynamic>> registerMeta() async {
    final response = await _dio.get(ApiConfig.registerMeta);
    return response.data;
  }

  /// ===============================
  /// POST /mobile/register
  /// ===============================
  Future<void> register(Map<String, dynamic> data) async {
    await _dio.post(ApiConfig.register, data: data);
  }

  /// ===============================
  /// POST /mobile/login
  /// ===============================
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );

    final auth = AuthResponseModel.fromJson(response.data);

    // 🔐 Simpan token di secure storage
    await _storage.write(key: 'token', value: auth.token);

    return auth;
  }

  /// ===============================
  /// GET TOKEN
  /// ===============================
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  /// ===============================
  /// CEK SUDAH LOGIN?
  /// ===============================
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.logout);
    } catch (_) {
      // abaikan error API
    }

    // 🔐 Hapus token dari secure storage
    await _storage.delete(key: 'token');
  }
}
