import 'campus_information_model.dart';
import '../campus/campus_information_meta.dart';

class CampusInformationResponse {
  final List<CampusInformationModel> data;
  final PaginationMeta meta;

  CampusInformationResponse({required this.data, required this.meta});

  factory CampusInformationResponse.fromJson(Map<String, dynamic> json) {
    return CampusInformationResponse(
      data: (json['data'] as List)
          .map((e) => CampusInformationModel.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}
