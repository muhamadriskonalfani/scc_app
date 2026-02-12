import 'apprenticeship_model.dart';
import './apprenticeship_meta.dart';

class ApprenticeshipResponse {
  final bool success;
  final String message;
  final List<ApprenticeshipModel> data;
  final PaginationMeta meta;

  ApprenticeshipResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ApprenticeshipResponse.fromJson(Map<String, dynamic> json) {
    return ApprenticeshipResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List? ?? [])
          .map((e) => ApprenticeshipModel.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
