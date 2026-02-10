class DirectoryMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  DirectoryMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory DirectoryMetaModel.fromJson(Map<String, dynamic> json) {
    return DirectoryMetaModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}
