class ProfileResponse {
  final bool exists;
  final Profile? profile;

  ProfileResponse({required this.exists, this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      exists: json['exists'] ?? false,
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : null,
    );
  }
}

class Profile {
  final int id;
  final int userId;
  final String? gender;
  final String? image;
  final String? phone;
  final String? testimonial;
  final String? bio;
  final String? education;
  final String? skills;
  final String? experience;
  final String? linkedinUrl;
  final String? cvFile;

  Profile({
    required this.id,
    required this.userId,
    this.gender,
    this.image,
    this.phone,
    this.testimonial,
    this.bio,
    this.education,
    this.skills,
    this.experience,
    this.linkedinUrl,
    this.cvFile,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      gender: json['gender'],
      image: json['image'],
      phone: json['phone'],
      testimonial: json['testimonial'],
      bio: json['bio'],
      education: json['education'],
      skills: json['skills'],
      experience: json['experience'],
      linkedinUrl: json['linkedin_url'],
      cvFile: json['cv_file'],
    );
  }
}
