import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';

class ProductModel {
  final String? id;
  final String sellerid;
  final String title;
  final String description;
  final double price;
  final int stock;
  final double taxAmount;
  final BrandModel brand; // your BrandModel instance
  final List<String> imageUrl;
  final String quantity;
  final List<String> videoUrl;
  final Timestamp createdAt;
  final double rating;

  ProductModel({
    this.id,
    required this.sellerid,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.taxAmount,
    required this.brand,
    required this.imageUrl,
    required this.quantity,
    required this.videoUrl,
    Timestamp? createdAt,
    required this.rating,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerid': sellerid,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'taxAmount': taxAmount,
      'brand': {
        'id': brand.id,
        'sellerId': brand.sellerId,
        'title': brand.title,
        'imageUrl': brand.imageUrl,
        'productsCount': brand.productsCount,
      },
      'imageUrl': imageUrl,
      'quantity': quantity,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String?,
      sellerid: map['sellerid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      stock: map['stock'] as int,
      taxAmount: (map['taxAmount'] as num).toDouble(),
      brand: BrandModel(
        id: map['brand']['id'] as String?,
        sellerId: map['brand']['sellerId'] as String,
        title: map['brand']['title'] as String,
        imageUrl: map['brand']['imageUrl'] as String,
        productsCount: map['brand']['productsCount'] as int,
      ),
      imageUrl: List<String>.from(map['imageUrl']),
      quantity: map['quantity'] as String,
      videoUrl: List<String>.from(map['videoUrl']),
      createdAt: map['createdAt'] ?? Timestamp.now(),
      rating: (map['rating'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, stock: $stock, brand: ${brand.title}, rating: $rating, createdAt: $createdAt, imageUrl: $imageUrl, videoUrl: $videoUrl, quantity: $quantity, taxAmount: $taxAmount, description: $description, sellerid: $sellerid, )';
  }
}
