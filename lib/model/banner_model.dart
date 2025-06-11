// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:desi_shopping_seller/model/product_model.dart';

class BannerModel {
  final String imageUrl;
  final ProductModel product;
  BannerModel({required this.imageUrl, required this.product});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'imageUrl': imageUrl, 'product': product.toMap()};
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      imageUrl: map['imageUrl'] as String,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
