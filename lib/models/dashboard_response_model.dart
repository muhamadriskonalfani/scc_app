class DashboardResponse {
  final bool success;
  final DashboardUser user;
  final List<CampusInfo> campusInfo;

  DashboardResponse({
    required this.success,
    required this.user,
    required this.campusInfo,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'],
      user: DashboardUser.fromJson(json['user']),
      campusInfo: (json['campus_info'] as List)
          .map((e) => CampusInfo.fromJson(e))
          .toList(),
    );
  }
}

class DashboardUser {
  final int id;
  final String name;
  final String? gender;
  final String? photo;
  final String? studentIdNumber;

  DashboardUser({
    required this.id,
    required this.name,
    this.gender,
    this.photo,
    this.studentIdNumber,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      photo: json['photo'],
      studentIdNumber: json['student_id_number'],
    );
  }
}

class CampusInfo {
  final int id;
  final String title;
  final String createdAt;
  final String? image;
  final String? description;

  CampusInfo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.image,
    this.description,
  });

  factory CampusInfo.fromJson(Map<String, dynamic> json) {
    return CampusInfo(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
      image: json['image'],
      description: json['description'],
    );
  }
}
