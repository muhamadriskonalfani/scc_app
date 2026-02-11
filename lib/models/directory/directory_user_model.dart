class DirectoryUserModel {
  final int id;
  final String name;
  final String? gender;
  final String? photo;
  final String? faculty;
  final String? studyProgram;
  final String? entryYear;
  final String status; // student | alumni

  DirectoryUserModel({
    required this.id,
    required this.name,
    this.gender,
    this.photo,
    this.faculty,
    this.studyProgram,
    this.entryYear,
    required this.status,
  });

  factory DirectoryUserModel.fromJson(Map<String, dynamic> json) {
    return DirectoryUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      photo: json['photo'] as String?,
      faculty: json['faculty'] as String?,
      studyProgram: json['study_program'] as String?,
      entryYear: json['entry_year'] as String?,
      status: json['status'] as String,
    );
  }
}
