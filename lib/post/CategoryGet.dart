class CategoryGet {
  final int categoryId;
  final String categoryName;
  final String categoryIconUrl;

  CategoryGet(
      {required this.categoryId,
      required this.categoryName,
      required this.categoryIconUrl});

  factory CategoryGet.fromJson(Map<String, dynamic> json) {
    return CategoryGet(
        categoryId: json['category_id'],
        categoryName: json['category_name'],
        categoryIconUrl: json['category_icon_url']);
  }
}
