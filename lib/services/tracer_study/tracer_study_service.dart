import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/tracer_study/tracer_study_model.dart';

class TracerStudyService {
  final Dio dio;

  TracerStudyService(this.dio);

  /// =========================
  /// GET Tracer Study
  /// =========================
  Future<TracerStudyModel?> getTracerStudy() async {
    try {
      final response = await dio.get(ApiConfig.tracerStudy);

      return TracerStudyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // tracer study belum ada
        return null;
      }
      rethrow;
    }
  }

  /// =========================
  /// UPDATE Tracer Study
  /// =========================
  Future<void> updateTracerStudy({
    required String domicile,
    required String whatsappNumber,
    String? currentWorkplace,
    int? currentJobDurationMonths,
    String? companyScale,
    String? jobTitle,
  }) async {
    try {
      await dio.put(
        ApiConfig.tracerStudy,
        data: {
          'domicile': domicile,
          'whatsapp_number': whatsappNumber,
          'current_workplace': currentWorkplace,
          'current_job_duration_months': currentJobDurationMonths,
          'company_scale': companyScale,
          'job_title': jobTitle,
        },
      );
    } on DioException catch (e) {
      // 422 -> validasi backend
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['errors']);
      }

      // 404 -> tracer study tidak ditemukan
      if (e.response?.statusCode == 404) {
        throw Exception('Tracer study tidak ditemukan');
      }

      rethrow;
    }
  }
}
