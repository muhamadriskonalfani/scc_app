import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/meta/faculty_model.dart';
import '../../models/meta/study_program_model.dart';

class MetaService {
  final Dio _dio;

  MetaService(this._dio);

  Future<
    ({List<FacultyModel> faculties, List<StudyProgramModel> studyPrograms})
  >
  getRegisterMeta() async {
    final response = await _dio.get(ApiConfig.registerMeta);

    if (response.data == null) {
      throw Exception('Gagal mengambil meta data');
    }

    final facultiesJson = response.data['faculties'] ?? [];
    final studyProgramsJson = response.data['study_programs'] ?? [];

    return (
      faculties: (facultiesJson as List)
          .map((e) => FacultyModel.fromJson(e))
          .toList(),
      studyPrograms: (studyProgramsJson as List)
          .map((e) => StudyProgramModel.fromJson(e))
          .toList(),
    );
  }
}
