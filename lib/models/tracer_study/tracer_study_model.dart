class TracerStudyModel {
  final String? image;
  final String? gender;
  final String? name;
  final String? nim;

  final String? faculty;
  final String? studyProgram;
  final String? entryYear;
  final String? graduationYear;
  final String? domicile;
  final String? phone;

  final String? employmentStatus;
  final String? currentWorkplace;
  final String? companyScale;
  final String? jobTitle;
  final String? jobCategory;
  final String? employmentType;
  final String? employmentSector;
  final String? monthlyIncomeRange;
  final String? jobStudyRelevanceLevel;
  final String? suggestionForUniversity;

  TracerStudyModel({
    this.image,
    this.gender,
    this.name,
    this.nim,
    this.faculty,
    this.studyProgram,
    this.entryYear,
    this.graduationYear,
    this.domicile,
    this.phone,
    this.employmentStatus,
    this.currentWorkplace,
    this.companyScale,
    this.jobTitle,
    this.jobCategory,
    this.employmentType,
    this.employmentSector,
    this.monthlyIncomeRange,
    this.jobStudyRelevanceLevel,
    this.suggestionForUniversity,
  });

  factory TracerStudyModel.fromJson(Map<String, dynamic> json) {
    return TracerStudyModel(
      image: json['image'],
      gender: json['gender'],
      name: json['name'],
      nim: json['nim'],
      faculty: json['faculty'],
      studyProgram: json['study_program'],
      entryYear: json['entry_year'],
      graduationYear: json['graduation_year'],
      domicile: json['domicile'],
      phone: json['phone'],
      employmentStatus: json['employment_status'],
      currentWorkplace: json['current_workplace'],
      companyScale: json['company_scale'],
      jobTitle: json['job_title'],
      jobCategory: json['job_category'],
      employmentType: json['employment_type'],
      employmentSector: json['employment_sector'],
      monthlyIncomeRange: json['monthly_income_range'],
      jobStudyRelevanceLevel: json['job_study_relevance_level'],
      suggestionForUniversity: json['suggestion_for_university'],
    );
  }
}
