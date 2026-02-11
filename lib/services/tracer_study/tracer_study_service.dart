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
      final Map<String, dynamic> data = {
        'domicile': domicile,
        'whatsapp_number': whatsappNumber,
      };

      if (currentWorkplace != null) {
        data['current_workplace'] = currentWorkplace;
      }

      if (currentJobDurationMonths != null) {
        data['current_job_duration_months'] = currentJobDurationMonths;
      }

      if (companyScale != null) {
        data['company_scale'] = companyScale;
      }

      if (jobTitle != null) {
        data['job_title'] = jobTitle;
      }

      await dio.put(ApiConfig.tracerStudy, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message'] ?? 'Validasi gagal');
      }

      if (e.response?.statusCode == 404) {
        throw Exception('Tracer study tidak ditemukan');
      }

      rethrow;
    }
  }
}
