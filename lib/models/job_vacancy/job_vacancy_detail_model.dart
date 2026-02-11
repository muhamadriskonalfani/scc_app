class JobVacancyDetailModel {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String? image;
  final DateTime? expiredAt;
  final String? creatorName;
  final DateTime createdAt;

  JobVacancyDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    this.image,
    this.expiredAt,
    this.creatorName,
    required this.createdAt,
  });

  factory JobVacancyDetailModel.fromJson(Map<String, dynamic> json) {
    return JobVacancyDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      expiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'])
          : null,
      creatorName: json['creator']?['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
