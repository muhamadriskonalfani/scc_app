import 'package:dio/dio.dart';

import '../../config/api_config.dart';
import '../../models/directory/directory_user_model.dart';
import '../../models/directory/directory_meta_model.dart';
import '../../models/directory/directory_detail_model.dart';

class DirectoryService {
  final Dio _dio;

  DirectoryService(this._dio);

  /// =========================
  /// GET DIRECTORY LIST
  /// =========================
  Future<({List<DirectoryUserModel> users, DirectoryMetaModel meta})>
  getDirectory({
    String? type,
    int? facultyId,
    int? studyProgramId,
    int? entryYear,
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConfig.directory,
      queryParameters: {
        'type': type,
        'faculty_id': facultyId,
        'study_program_id': studyProgramId,
        'entry_year': entryYear,
        'page': page,
      },
    );

    final data = response.data['data'] as List;
    final meta = response.data['meta'];

    return (
      users: data.map((e) => DirectoryUserModel.fromJson(e)).toList(),
      meta: DirectoryMetaModel.fromJson(meta),
    );
  }

  /// =========================
  /// GET DIRECTORY DETAIL
  /// =========================
  Future<DirectoryDetailModel> getDirectoryDetail(int id) async {
    final response = await _dio.get(ApiConfig.directoryDetail(id));

    return DirectoryDetailModel.fromJson(response.data['data']);
  }
}
