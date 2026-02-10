class CampusInformationModel {
  final int id;
  final String title;
  final String? image;
  final String excerpt;
  final String createdAt;

  CampusInformationModel({
    required this.id,
    required this.title,
    this.image,
    required this.excerpt,
    required this.createdAt,
  });

  factory CampusInformationModel.fromJson(Map<String, dynamic> json) {
    return CampusInformationModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      excerpt: json['excerpt'],
      createdAt: json['created_at'],
    );
  }
}
