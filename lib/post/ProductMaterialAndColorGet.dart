class ProductMaterialAndColor {
  final String colorName;
  final String materialName;

  ProductMaterialAndColor({
    required this.colorName,
    required this.materialName,
  });
  factory ProductMaterialAndColor.fromJson(Map<String, dynamic> json) {
    return ProductMaterialAndColor(
        colorName: json['color_name'], materialName: json['material_name']);
  }
}
