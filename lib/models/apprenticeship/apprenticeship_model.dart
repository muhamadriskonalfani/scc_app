class Apprenticeship {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String? image;
  final DateTime createdAt;

  Apprenticeship({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    this.image,
    required this.createdAt,
  });

  factory Apprenticeship.fromJson(Map<String, dynamic> json) {
    return Apprenticeship(
      id: json['id'],
      title: json['title'],
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
