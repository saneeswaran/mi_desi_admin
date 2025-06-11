import 'dart:convert';

class BannerModel {
  final String bannerId;
  final String imageUrl;
  final String productId;
  BannerModel({
    required this.bannerId,
    required this.imageUrl,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bannerId': bannerId,
      'imageUrl': imageUrl,
      'productId': productId,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      bannerId: map['bannerId'] as String,
      imageUrl: map['imageUrl'] as String,
      productId: map['productId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
