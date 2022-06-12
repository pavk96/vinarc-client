class ProductGet {
  final int? productNumber;
  final int? shippingFee;
  final String? productName;
  final String? productSize;
  final String? productPrice;
  final String? productSortNumber;
  final int? productClass;
  final String? productThumnailUrl;

  ProductGet(
      {this.productNumber,
      this.shippingFee,
      this.productName,
      this.productSize,
      this.productPrice,
      this.productSortNumber,
      this.productClass,
      this.productThumnailUrl});
  factory ProductGet.fromJson(Map<String, dynamic> json) {
    return ProductGet(
        productNumber: json['product_number'],
        shippingFee: json['shipping_fee'],
        productName: json['product_name'],
        productSize: json['product_size'],
        productPrice: json['product_price'],
        productSortNumber: json['product_sort_number'],
        productClass: json['product_class'],
        productThumnailUrl: json['product_thumnail_url']);
  }
}
