import 'package:cloud_firestore/cloud_firestore.dart';
import 'brand_model.dart';

class ProductModel {
  final String? id;
  final String sellerid;
  final String title;
  final String description;
  final double price;
  final int stock;
  final double taxAmount;
  final String cashOnDelivery;
  final BrandModel brand;
  final List<String> imageUrl;
  final List<String> videoUrl;
  final Timestamp createdAt = Timestamp.now();
  double rating;

  ProductModel({
    this.id,
    required this.sellerid,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.taxAmount,
    required this.cashOnDelivery,
    required this.brand,
    required this.imageUrl,
    required this.videoUrl,
    double? rating,
  }) : rating = rating ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerid': sellerid,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'taxAmount': taxAmount,
      'cashOnDelivery': cashOnDelivery,
      'brand': {
        'id': brand.id,
        'sellerId': brand.sellerId,
        'title': brand.title,
        'imageUrl': brand.imageUrl,
        'productsCount': brand.productsCount,
      },
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      sellerid: map['sellerid'],
      title: map['title'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      stock: map['stock'],
      taxAmount: (map['taxAmount'] as num).toDouble(),
      cashOnDelivery: map['cashOnDelivery'],
      brand: BrandModel(
        id: map['brand']['id'],
        sellerId: map['brand']['sellerId'],
        title: map['brand']['title'],
        imageUrl: map['brand']['imageUrl'],
        productsCount: map['brand']['productsCount'],
      ),
      imageUrl: List<String>.from(map['imageUrl']),
      videoUrl: List<String>.from(map['videoUrl']),
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? sellerid,
    String? title,
    String? description,
    double? price,
    int? stock,
    double? taxAmount,
    String? cashOnDelivery,
    BrandModel? brand,
    List<String>? imageUrl,
    List<String>? videoUrl,
    Timestamp? createdAt,
    double? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sellerid: sellerid ?? this.sellerid,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      taxAmount: taxAmount ?? this.taxAmount,
      cashOnDelivery: cashOnDelivery ?? this.cashOnDelivery,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title)';
  }
}
