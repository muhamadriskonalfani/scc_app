class CampusInformationDetailModel {
  final int id;
  final String title;
  final String? image;
  final String description;
  final String createdAt;
  final String faculty;
  final String createdBy;

  CampusInformationDetailModel({
    required this.id,
    required this.title,
    this.image,
    required this.description,
    required this.createdAt,
    required this.faculty,
    required this.createdBy,
  });

  factory CampusInformationDetailModel.fromJson(Map<String, dynamic> json) {
    return CampusInformationDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      faculty: json['faculty'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }
}
