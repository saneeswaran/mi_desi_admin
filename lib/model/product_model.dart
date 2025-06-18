import 'package:cloud_firestore/cloud_firestore.dart';
import 'brand_model.dart';

class ProductModel {
  final String? id;
  final String sellerid;
  final String title;
  final String description;
  final double price;
  final String? netVolume;
  final String? dosage;
  final String? composition;
  final String? storage;
  final String? manufacturedBy;
  final String? marketedBy;
  final String? shelfLife;
  final String? additionalInformation;
  final int stock;
  final double taxAmount;
  final String cashOnDelivery;
  final BrandModel brand;
  final List<String> imageUrl;
  final List<String> videoUrl;
  final int? offerPrice;
  final Timestamp createdAt = Timestamp.now();
  double rating;

  ProductModel({
    this.id,
    required this.sellerid,
    required this.title,
    required this.description,
    required this.price,
    this.netVolume,
    this.dosage,
    this.composition,
    this.storage,
    this.manufacturedBy,
    this.marketedBy,
    this.shelfLife,
    this.additionalInformation,
    required this.stock,
    required this.taxAmount,
    required this.cashOnDelivery,
    required this.brand,
    required this.imageUrl,
    required this.videoUrl,
    this.offerPrice,
    double? rating,
  }) : rating = rating ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerid': sellerid,
      'title': title,
      'description': description,
      'price': price,
      'netVolume': netVolume,
      'dosage': dosage,
      'composition': composition,
      'storage': storage,
      'manufacturedBy': manufacturedBy,
      'marketedBy': marketedBy,
      'shelfLife': shelfLife,
      'additionalInformation': additionalInformation,
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
      'offerPrice': offerPrice,
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
      netVolume: map['netVolume'] as String,
      dosage: map['dosage'] as String,
      composition: map['composition'] as String,
      storage: map['storage'] as String,
      manufacturedBy: map['manufacturedBy'] as String,
      marketedBy: map['marketedBy'] as String,
      shelfLife: map['shelfLife'] as String,
      additionalInformation: map['additionalInformation'],
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
      offerPrice: map['offerPrice'] as int?,
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? sellerid,
    String? title,
    String? description,
    double? price,
    String? netVolume,
    String? dosage,
    String? composition,
    String? storage,
    String? manufacturedBy,
    String? marketedBy,
    String? shelfLife,
    String? additionalInformation,
    int? stock,
    double? taxAmount,
    String? cashOnDelivery,
    BrandModel? brand,
    List<String>? imageUrl,
    List<String>? videoUrl,
    Timestamp? createdAt,
    int? offerPrice,
    double? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sellerid: sellerid ?? this.sellerid,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      netVolume: netVolume ?? this.netVolume,
      dosage: dosage ?? this.dosage,
      composition: composition ?? this.composition,
      storage: storage ?? this.storage,
      manufacturedBy: manufacturedBy ?? this.manufacturedBy,
      marketedBy: marketedBy ?? this.marketedBy,
      shelfLife: shelfLife ?? this.shelfLife,
      additionalInformation:
          additionalInformation ?? this.additionalInformation,
      stock: stock ?? this.stock,
      taxAmount: taxAmount ?? this.taxAmount,
      cashOnDelivery: cashOnDelivery ?? this.cashOnDelivery,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      offerPrice: offerPrice ?? this.offerPrice,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title)';
  }
}
