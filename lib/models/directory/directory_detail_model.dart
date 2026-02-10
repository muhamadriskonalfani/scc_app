class DirectoryDetailModel {
  final String name;
  final String? gender;
  final String? photo;
  final String status;
  final String? faculty;
  final String? studyProgram;
  final int? entryYear;
  final int? graduationYear;
  final String? jobTitle;
  final String? currentWorkplace;
  final String? bio;
  final String? skills;
  final String? testimonial;

  DirectoryDetailModel({
    required this.name,
    this.gender,
    this.photo,
    required this.status,
    this.faculty,
    this.studyProgram,
    this.entryYear,
    this.graduationYear,
    this.jobTitle,
    this.currentWorkplace,
    this.bio,
    this.skills,
    this.testimonial,
  });

  factory DirectoryDetailModel.fromJson(Map<String, dynamic> json) {
    return DirectoryDetailModel(
      name: json['name'],
      gender: json['gender'],
      photo: json['photo'],
      status: json['status'],
      faculty: json['faculty'],
      studyProgram: json['study_program'],
      entryYear: json['entry_year'],
      graduationYear: json['graduation_year'],
      jobTitle: json['job_title'],
      currentWorkplace: json['current_workplace'],
      bio: json['bio'],
      skills: json['skills'],
      testimonial: json['testimonial'],
    );
  }
}
