import 'faculty_model.dart';
import 'study_program_model.dart';

class TracerStudyModel {
  final int id;
  final String? domicile;
  final String? whatsappNumber;

  final String? currentWorkplace;
  final int? currentJobDurationMonths;
  final String? companyScale;
  final String? jobTitle;

  final FacultyModel? faculty;
  final StudyProgramModel? studyProgram;

  TracerStudyModel({
    required this.id,
    this.domicile,
    this.whatsappNumber,
    this.currentWorkplace,
    this.currentJobDurationMonths,
    this.companyScale,
    this.jobTitle,
    this.faculty,
    this.studyProgram,
  });

  factory TracerStudyModel.fromJson(Map<String, dynamic> json) {
    return TracerStudyModel(
      id: json['id'],
      domicile: json['domicile'],
      whatsappNumber: json['whatsapp_number'],
      currentWorkplace: json['current_workplace'],
      currentJobDurationMonths: json['current_job_duration_months'],
      companyScale: json['company_scale'],
      jobTitle: json['job_title'],
      faculty: json['faculty'] != null
          ? FacultyModel.fromJson(json['faculty'])
          : null,
      studyProgram: json['study_program'] != null
          ? StudyProgramModel.fromJson(json['study_program'])
          : null,
    );
  }
}
