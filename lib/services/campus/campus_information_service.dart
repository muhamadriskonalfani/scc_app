import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/campus/campus_information_response.dart';
import '../../models/campus/campus_information_detail_model.dart';

class CampusInformationService {
  final Dio dio;

  CampusInformationService(this.dio);

  /// List informasi kampus (pagination)
  Future<CampusInformationResponse> getInformations({int page = 1}) async {
    final response = await dio.get(
      ApiConfig.campusInformation,
      queryParameters: {'page': page},
    );

    return CampusInformationResponse.fromJson(response.data);
  }

  /// Detail informasi kampus
  Future<CampusInformationDetailModel> getInformationDetail(int id) async {
    final response = await dio.get(ApiConfig.campusInformationDetail(id));

    return CampusInformationDetailModel.fromJson(response.data);
  }
}
