import 'package:dio/dio.dart';

import '../../config/api_config.dart';
import '../../models/job_vacancy/job_vacancy_model.dart';
import '../../models/job_vacancy/job_vacancy_detail_model.dart';
import '../../models/job_vacancy/pagination_meta.dart';

class JobVacancyService {
  final Dio dio;

  JobVacancyService(this.dio);

  /// =========================
  /// LIST JOB VACANCY (STUDENT & ALUMNI)
  /// =========================
  Future<({List<JobVacancy> data, PaginationMeta meta})> fetchJobVacancies({
    int page = 1,
  }) async {
    final response = await dio.get(
      ApiConfig.jobVacancy,
      queryParameters: {'page': page},
    );

    final json = response.data;

    final items = (json['data'] as List)
        .map((e) => JobVacancy.fromJson(e))
        .toList();

    final meta = PaginationMeta.fromJson(json['meta']);

    return (data: items, meta: meta);
  }

  /// =========================
  /// DETAIL JOB VACANCY
  /// =========================
  Future<JobVacancyDetailModel> fetchJobVacancyDetail(int id) async {
    final response = await dio.get(ApiConfig.jobVacancyDetail(id));
    return JobVacancyDetailModel.fromJson(response.data['data']);
  }

  /// =========================
  /// ALUMNI: MY JOB VACANCY
  /// =========================
  Future<({List<JobVacancy> data, PaginationMeta meta})> fetchMyJobVacancies({
    int page = 1,
  }) async {
    final response = await dio.get(
      ApiConfig.myJobVacancy,
      queryParameters: {'page': page},
    );

    final json = response.data['data'];

    final items = (json['data'] as List)
        .map((e) => JobVacancy.fromJson(e))
        .toList();

    final meta = PaginationMeta.fromJson(json);

    return (data: items, meta: meta);
  }
}
