class JobVacancyModel {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String? image;
  final String? description;
  final DateTime createdAt;
  final String? expiredAt;
  final String status;
  final String? applicationLink;

  JobVacancyModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    this.image,
    this.description,
    this.expiredAt,
    required this.createdAt,
    required this.status,
    this.applicationLink,
  });

  factory JobVacancyModel.fromJson(Map<String, dynamic> json) {
    return JobVacancyModel(
      id: json['id'],
      title: json['title'],
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      description: json['description'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiredAt: json['expired_at'],
      status: json['status'] ?? 'pending',
      applicationLink: json['application_link'] ?? '',
    );
  }
}
