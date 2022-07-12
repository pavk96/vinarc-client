class ProductReviewGet {
  final int productNumber;
  final int userNumber;
  final String reviewTitle;
  final String reviewContents;
  final String reviewImageUrl;
  final String reviewDate;
  final String userId;

  ProductReviewGet(
      {required this.productNumber,
      required this.reviewContents,
      required this.reviewDate,
      required this.reviewImageUrl,
      required this.reviewTitle,
      required this.userNumber,
      required this.userId});
  factory ProductReviewGet.fromJson(Map<String, dynamic> json) {
    return ProductReviewGet(
        productNumber: json['r_product_number'],
        userNumber: json['r_user_number'],
        reviewTitle: json['r_review_title'],
        reviewContents: json['r_review_contents'],
        reviewImageUrl: json['r_review_image_url'],
        reviewDate: json['r_review_date'],
        userId: json['u_user_id']);
  }
}
