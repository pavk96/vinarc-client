class ProductMaterialAndColor {
  final int productMaterialAndColorId;
  final int productNumber;
  final String productMaterialAndColorImageUrl;
  final String colorName;
  final String materialName;

  ProductMaterialAndColor({
    required this.productMaterialAndColorId,
    required this.productNumber,
    required this.productMaterialAndColorImageUrl,
    required this.colorName,
    required this.materialName,
  });
  factory ProductMaterialAndColor.fromJson(Map<String, dynamic> json) {
    return ProductMaterialAndColor(
        productMaterialAndColorId: json['product_material_and_color_id'],
        productNumber: json['product_number'],
        productMaterialAndColorImageUrl:
            json['product_material_and_color_image_url'],
        colorName: json['product_color_name'],
        materialName: json['product_material_name']);
  }
}
