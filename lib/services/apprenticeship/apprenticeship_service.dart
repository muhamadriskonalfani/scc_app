import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/apprenticeship/apprenticeship_response_model.dart';
import '../../models/apprenticeship/apprenticeship_detail_model.dart';

class ApprenticeshipService {
  final Dio _dio;

  ApprenticeshipService(this._dio);

  /// List semua magang (student & alumni)
  Future<ApprenticeshipResponse> getApprenticeships({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.apprenticeship,
      queryParameters: {'page': page},
    );

    return ApprenticeshipResponse.fromJson(response.data);
  }

  /// Detail magang
  Future<ApprenticeshipDetail> getApprenticeshipDetail(int id) async {
    final response = await _dio.get(ApiConfig.apprenticeshipDetail(id));

    return ApprenticeshipDetail.fromJson(response.data['data']);
  }

  /// Alumni: magang milik sendiri
  Future<ApprenticeshipResponse> getMyApprenticeships({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.myApprenticeship,
      queryParameters: {'page': page},
    );

    return ApprenticeshipResponse.fromJson(response.data);
  }
}
