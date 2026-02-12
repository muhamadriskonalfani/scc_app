import 'job_vacancy_model.dart';
import 'job_vacancy_meta.dart';

class JobVacancyResponse {
  final bool success;
  final String message;
  final List<JobVacancyModel> data;
  final JobPaginationMeta meta;

  JobVacancyResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory JobVacancyResponse.fromJson(Map<String, dynamic> json) {
    return JobVacancyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => JobVacancyModel.fromJson(e))
          .toList(),
      meta: JobPaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
