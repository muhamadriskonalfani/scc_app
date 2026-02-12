class ApprenticeshipModel {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String? image;
  final String? description;
  final DateTime createdAt;
  final String? expiredAt;

  ApprenticeshipModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    this.image,
    this.description,
    this.expiredAt,
    required this.createdAt,
  });

  factory ApprenticeshipModel.fromJson(Map<String, dynamic> json) {
    return ApprenticeshipModel(
      id: json['id'],
      title: json['title'],
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      description: json['description'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiredAt: json['expired_at'],
    );
  }
}
