class JobVacancy {
  final int id;
  final String title;
  final String companyName;
  final String location;
  final String? image;
  final DateTime createdAt;

  JobVacancy({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    this.image,
    required this.createdAt,
  });

  factory JobVacancy.fromJson(Map<String, dynamic> json) {
    return JobVacancy(
      id: json['id'],
      title: json['title'],
      companyName: json['company_name'],
      location: json['location'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
