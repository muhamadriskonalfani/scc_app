class DirectoryDetailModel {
  final String name;
  final String? gender;
  final String? photo;
  final String status;
  final String? faculty;
  final String? studyProgram;
  final String? entryYear;
  final String? graduationYear;
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
      name: json['name'] as String,
      gender: json['gender'] as String?,
      photo: json['photo'] as String?,
      status: json['status'] as String,
      faculty: json['faculty'] as String?,
      studyProgram: json['study_program'] as String?,
      entryYear: json['entry_year'] as String?,
      graduationYear: json['graduation_year'] as String?,
      jobTitle: json['job_title'] as String?,
      currentWorkplace: json['current_workplace'] as String?,
      bio: json['bio'] as String?,
      skills: json['skills'] as String?,
      testimonial: json['testimonial'] as String?,
    );
  }
}
