class CampusInformationDetailModel {
  final int id;
  final String title;
  final String? image;
  final String description;
  final String createdAt;

  CampusInformationDetailModel({
    required this.id,
    required this.title,
    this.image,
    required this.description,
    required this.createdAt,
  });

  factory CampusInformationDetailModel.fromJson(Map<String, dynamic> json) {
    return CampusInformationDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
