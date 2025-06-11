// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:desi_shopping_seller/model/product_model.dart';

class BannerModel {
  final String imageUrl;
  final String bannerId;
  final ProductModel product;
  BannerModel({
    required this.imageUrl,
    required this.product,
    required this.bannerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'bannerId': bannerId,
      'product': product.toMap(),
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      imageUrl: map['imageUrl'] as String,
      bannerId: map['bannerId'] as String,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
