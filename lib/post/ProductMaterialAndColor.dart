class ProductMaterialAndColor {
  final int materialId;
  final int productNumber;
  final String colorId;

  ProductMaterialAndColor(
      {required this.materialId,
      required this.productNumber,
      required this.colorId});
  factory ProductMaterialAndColor.fromJson(Map<String, dynamic> json) {
    return ProductMaterialAndColor(
        materialId: json['material_id'],
        productNumber: json['product_number'],
        colorId: json['color_id']);
  }
}
