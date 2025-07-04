// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  final BrandModel categoryBrand;
  final BrandModel realBrand;
  final List<String> imageUrl;
  final List<String> videoUrl;
  final int? offerPrice;
  bool? isBestSelling = false;
  final Timestamp createdAt = Timestamp.now();
  double rating;

  ProductModel({
    double? rating,
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
    required this.categoryBrand,
    required this.realBrand,
    required this.imageUrl,
    required this.videoUrl,
    this.offerPrice,
    this.isBestSelling,
  }) : rating = rating ?? 0.0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'categoryBrand': categoryBrand.toMap(),
      'realBrand': realBrand.toMap(),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'offerPrice': offerPrice,
      'isBestSelling': isBestSelling,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      sellerid: map['sellerid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      netVolume: map['netVolume'] != null ? map['netVolume'] as String : null,
      dosage: map['dosage'] != null ? map['dosage'] as String : null,
      composition: map['composition'] != null
          ? map['composition'] as String
          : null,
      storage: map['storage'] != null ? map['storage'] as String : null,
      manufacturedBy: map['manufacturedBy'] != null
          ? map['manufacturedBy'] as String
          : null,
      marketedBy: map['marketedBy'] != null
          ? map['marketedBy'] as String
          : null,
      shelfLife: map['shelfLife'] != null ? map['shelfLife'] as String : null,
      additionalInformation: map['additionalInformation'] != null
          ? map['additionalInformation'] as String
          : null,
      stock: map['stock'] as int,
      taxAmount: map['taxAmount'] as double,
      cashOnDelivery: map['cashOnDelivery'] as String,
      categoryBrand: BrandModel.fromMap(
        map['categoryBrand'] as Map<String, dynamic>,
      ),
      realBrand: BrandModel.fromMap(map['realBrand'] as Map<String, dynamic>),
      imageUrl: List<String>.from((map['imageUrl'] as List<String>)),
      videoUrl: List<String>.from((map['videoUrl'] as List<String>)),
      offerPrice: map['offerPrice'] != null ? map['offerPrice'] as int : null,
      isBestSelling: map['isBestSelling'] != null
          ? map['isBestSelling'] as bool
          : null,
      rating: map['rating'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, sellerid: $sellerid, title: $title, description: $description, price: $price, netVolume: $netVolume, dosage: $dosage, composition: $composition, storage: $storage, manufacturedBy: $manufacturedBy, marketedBy: $marketedBy, shelfLife: $shelfLife, additionalInformation: $additionalInformation, stock: $stock, taxAmount: $taxAmount, cashOnDelivery: $cashOnDelivery, categoryBrand: $categoryBrand, realBrand: $realBrand, imageUrl: $imageUrl, videoUrl: $videoUrl, offerPrice: $offerPrice, isBestSelling: $isBestSelling, rating: $rating)';
  }
}
