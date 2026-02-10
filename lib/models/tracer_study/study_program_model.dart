class StudyProgramModel {
  final int id;
  final String name;

  StudyProgramModel({required this.id, required this.name});

  factory StudyProgramModel.fromJson(Map<String, dynamic> json) {
    return StudyProgramModel(id: json['id'], name: json['name']);
  }
}
