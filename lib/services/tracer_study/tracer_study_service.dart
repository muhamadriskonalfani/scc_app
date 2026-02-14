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
    String? employmentStatus,
    String? currentWorkplace,
    String? companyScale,
    String? jobTitle,
    String? jobCategory,
    String? employmentType,
    String? employmentSector,
    String? monthlyIncomeRange,
    String? jobStudyRelevanceLevel,
    String? suggestionForUniversity,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (employmentStatus != null) {
        data['employment_status'] = employmentStatus;
      }

      if (currentWorkplace != null) {
        data['current_workplace'] = currentWorkplace;
      }

      if (companyScale != null) {
        data['company_scale'] = companyScale;
      }

      if (jobTitle != null) {
        data['job_title'] = jobTitle;
      }

      if (jobCategory != null) {
        data['job_category'] = jobCategory;
      }

      if (employmentType != null) {
        data['employment_type'] = employmentType;
      }

      if (employmentSector != null) {
        data['employment_sector'] = employmentSector;
      }

      if (monthlyIncomeRange != null) {
        data['monthly_income_range'] = monthlyIncomeRange;
      }

      if (jobStudyRelevanceLevel != null) {
        data['job_study_relevance_level'] = jobStudyRelevanceLevel;
      }

      if (suggestionForUniversity != null) {
        data['suggestion_for_university'] = suggestionForUniversity;
      }

      await dio.put(ApiConfig.tracerStudy, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message'] ?? 'Validasi gagal');
      }

      if (e.response?.statusCode == 404) {
        throw Exception('Tracer study tidak ditemukan');
      }

      throw Exception('Terjadi kesalahan server');
    }
  }
}
