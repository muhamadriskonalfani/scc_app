class ProfileResponse {
  final bool success;
  final ProfileData? profile;
  final String? message;

  ProfileResponse({required this.success, this.profile, this.message});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      profile: json['profile'] != null
          ? ProfileData.fromJson(json['profile'])
          : null,
      message: json['message'],
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final String role;
  final String? image;
  final String? gender;
  final String? nim;
  final String? faculty;
  final String? studyProgram;
  final String? entryYear;

  ProfileData({
    required this.name,
    required this.email,
    required this.role,
    this.image,
    this.gender,
    this.nim,
    this.faculty,
    this.studyProgram,
    this.entryYear,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      image: json['image'],
      gender: json['gender'],
      nim: json['nim'],
      faculty: json['faculty'],
      studyProgram: json['study_program'],
      entryYear: json['entry_year']?.toString(),
    );
  }
}
