class JobVacancyDetail {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String? image;
  final DateTime createdAt;
  final DateTime? expiredAt;
  final JobCreator? creator;
  final String? applicationLink;

  JobVacancyDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    this.image,
    required this.createdAt,
    this.expiredAt,
    this.creator,
    this.applicationLink,
  });

  factory JobVacancyDetail.fromJson(Map<String, dynamic> json) {
    return JobVacancyDetail(
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
          ? JobCreator.fromJson(json['creator'])
          : null,
      applicationLink: json['application_link'],
    );
  }
}

class JobCreator {
  final int id;
  final String name;

  JobCreator({required this.id, required this.name});

  factory JobCreator.fromJson(Map<String, dynamic> json) {
    return JobCreator(id: json['id'], name: json['name']);
  }
}
