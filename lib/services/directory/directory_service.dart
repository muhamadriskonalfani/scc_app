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
    try {
      final query = <String, dynamic>{'page': page};

      if (type != null) query['type'] = type;
      if (facultyId != null) query['faculty_id'] = facultyId;
      if (studyProgramId != null) {
        query['study_program_id'] = studyProgramId;
      }
      if (entryYear != null) query['entry_year'] = entryYear;

      final response = await _dio.get(
        ApiConfig.directory,
        queryParameters: query,
      );

      if (response.data['success'] != true) {
        throw Exception('Gagal mengambil data directory');
      }

      final List dataList = response.data['data'];
      final metaJson = response.data['meta'];

      return (
        users: dataList.map((e) => DirectoryUserModel.fromJson(e)).toList(),
        meta: DirectoryMetaModel.fromJson(metaJson),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat directory');
    }
  }

  /// =========================
  /// GET DIRECTORY DETAIL
  /// =========================
  Future<DirectoryDetailModel> getDirectoryDetail(int id) async {
    try {
      final response = await _dio.get(ApiConfig.directoryDetail(id));

      if (response.data['success'] != true) {
        throw Exception('Data directory tidak ditemukan');
      }

      return DirectoryDetailModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat detail');
    }
  }
}
