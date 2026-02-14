class ProfileResponse {
  final bool success;
  final ProfileData? profile;

  ProfileResponse({required this.success, this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      profile: json['profile'] != null
          ? ProfileData.fromJson(json['profile'])
          : null,
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final String role;
  final String? gender;
  final String? image;
  final String? phone;
  final String? domicile;
  final String? testimonial;
  final String? bio;
  final String? education;
  final String? skills;
  final String? experience;
  final String? linkedinUrl;
  final String? cvFile;
  final String? alumniTag;
  final String? nim;
  final String? faculty;
  final String? studyProgram;
  final String? entryYear;
  final String? employmentStatus;
  final String? employmentType;
  final String? currentWorkplace;
  final String? jobTitle;
  final String? jobCategory;
  final String? suggestionForUniversity;

  ProfileData({
    required this.name,
    required this.email,
    required this.role,
    this.gender,
    this.image,
    this.phone,
    this.domicile,
    this.testimonial,
    this.bio,
    this.education,
    this.skills,
    this.experience,
    this.linkedinUrl,
    this.cvFile,
    this.alumniTag,
    this.nim,
    this.faculty,
    this.studyProgram,
    this.entryYear,
    this.employmentStatus,
    this.employmentType,
    this.currentWorkplace,
    this.jobTitle,
    this.jobCategory,
    this.suggestionForUniversity,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      gender: json['gender'],
      image: json['image'],
      phone: json['phone'],
      domicile: json['domicile'],
      testimonial: json['testimonial'],
      bio: json['bio'],
      education: json['education'],
      skills: json['skills'],
      experience: json['experience'],
      linkedinUrl: json['linkedin_url'],
      cvFile: json['cv_file'],
      alumniTag: json['alumni_tag'],
      nim: json['nim'],
      faculty: json['faculty'],
      studyProgram: json['study_program'],
      entryYear: json['entry_year'],
      employmentStatus: json['employment_status'],
      employmentType: json['employment_type'],
      currentWorkplace: json['current_workplace'],
      jobTitle: json['job_title'],
      jobCategory: json['job_category'],
      suggestionForUniversity: json['suggestion_for_university'],
    );
  }
}
