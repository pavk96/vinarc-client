class ProductDetailImage {
  final int imageId;
  final int productNumber;
  final String ProductImageUrl;

  ProductDetailImage(
      {required this.imageId,
      required this.productNumber,
      required this.ProductImageUrl});
  factory ProductDetailImage.fromJson(Map<String, dynamic> json) {
    return ProductDetailImage(
        imageId: json['image_id'],
        productNumber: json['product_number'],
        ProductImageUrl: json['product_image_url']);
  }
}
