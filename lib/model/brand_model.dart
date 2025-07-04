import 'dart:convert';

class BrandModel {
  final String? id;
  final String sellerId;
  final String title;
  final String imageUrl;
  final String? backGroundImage;
  int productsCount;

  BrandModel({
    this.id,
    required this.sellerId,
    required this.title,
    required this.imageUrl,
    this.backGroundImage,
    this.productsCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'title': title,
      'imageUrl': imageUrl,
      'backGroundImage': backGroundImage,
      'productsCount': productsCount,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'],
      sellerId: map['sellerId'],
      title: map['title'],
      backGroundImage: map['backGroundImage'] ?? '',
      imageUrl: map['imageUrl'],
      productsCount: map['productsCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) =>
      BrandModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is BrandModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BrandModel(id: $id, sellerId: $sellerId, title: $title, imageUrl: $imageUrl, productsCount: $productsCount)';
  }
}
