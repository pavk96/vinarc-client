class ProductDetailGet {
  final int productNumber;
  final String productManufactor;
  final String productCountryOfManufactor;
  final String productMainMaterial;
  final String productComponents;
  final String productAssurance;
  final String productResponsible;
  final String productResponsiblePhone;
  final String estimatedDeliveryDate;
  final String productDetailImageUrl;

  ProductDetailGet(
      {required this.productNumber,
      required this.productAssurance,
      required this.estimatedDeliveryDate,
      required this.productComponents,
      required this.productCountryOfManufactor,
      required this.productMainMaterial,
      required this.productManufactor,
      required this.productResponsible,
      required this.productResponsiblePhone,
      required this.productDetailImageUrl});
  factory ProductDetailGet.fromJson(Map<String, dynamic> json) {
    return ProductDetailGet(
        productNumber: json['product_number'],
        productManufactor: json['product_manufactor'],
        productCountryOfManufactor: json['product_country_of_manufactor'],
        productMainMaterial: json['product_main_material'],
        productComponents: json['product_components'],
        productAssurance: json['product_assurance'],
        productResponsible: json['product_responsible'],
        productResponsiblePhone: json['product_responsible_phone'],
        estimatedDeliveryDate: json['estimated_delivery_date'],
        productDetailImageUrl: json['product_detail_image_url']);
  }
}
