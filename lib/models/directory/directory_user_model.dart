class DirectoryUserModel {
  final int id;
  final String name;
  final String? gender;
  final String? photo;
  final String? faculty;
  final String? studyProgram;
  final int? entryYear;
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
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      photo: json['photo'],
      faculty: json['faculty'],
      studyProgram: json['study_program'],
      entryYear: json['entry_year'],
      status: json['status'],
    );
  }
}
