class ProductMaterialAndColor {
  final String materialName;
  final String colorName;

  ProductMaterialAndColor({
    required this.materialName,
    required this.colorName,
  });
  factory ProductMaterialAndColor.fromJson(Map<String, dynamic> json) {
    return ProductMaterialAndColor(
      materialName: json['material_name'],
      colorName: json['color_name'],
    );
  }
}
