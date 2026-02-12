class ApprenticeshipDetail {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String? image;
  final DateTime createdAt;
  final DateTime? expiredAt;
  final Creator? creator;

  ApprenticeshipDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    this.image,
    required this.createdAt,
    this.expiredAt,
    this.creator,
  });

  factory ApprenticeshipDetail.fromJson(Map<String, dynamic> json) {
    return ApprenticeshipDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      expiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'])
          : null,
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
    );
  }
}

class Creator {
  final int id;
  final String name;

  Creator({required this.id, required this.name});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(id: json['id'], name: json['name']);
  }
}
