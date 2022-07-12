class ProductReviewGet {
  final int productNumber;
  final int userNumber;
  final String reviewTitle;
  final String reviewContents;
  final String reviewImageUrl;
  final String reviewDate;
  ProductReviewGet(
      {required this.productNumber,
      required this.reviewContents,
      required this.reviewDate,
      required this.reviewImageUrl,
      required this.reviewTitle,
      required this.userNumber});
  factory ProductReviewGet.fromJson(Map<String, dynamic> json) {
    return ProductReviewGet(
        productNumber: json['product_number'],
        userNumber: json['user_number'],
        reviewTitle: json['review_title'],
        reviewContents: json['review_contents'],
        reviewImageUrl: json['review_image_url'],
        reviewDate: json['review_date']);
  }
}
