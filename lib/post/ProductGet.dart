import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

class ProductGet {
  final int productNumber;
  final int shippingFee;
  final String productName;
  final String productSize;
  final String productPrice;
  final String productSortNumber;
  final int productClass;
  final String productThumnailUrl;

  ProductGet(
      {required this.productNumber,
      required this.shippingFee,
      required this.productName,
      required this.productSize,
      required this.productPrice,
      required this.productSortNumber,
      required this.productClass,
      required this.productThumnailUrl});
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
