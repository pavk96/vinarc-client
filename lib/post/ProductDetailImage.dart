class ProductDetailImage {
  final int imageId;
  final int productNumber;
  final String productImageUrl;

  ProductDetailImage(
      {required this.imageId,
      required this.productNumber,
      required this.productImageUrl});
  factory ProductDetailImage.fromJson(Map<String, dynamic> json) {
    return ProductDetailImage(
        imageId: json['image_id'],
        productNumber: json['product_number'],
        productImageUrl: json['product_image_url']);
  }
}
