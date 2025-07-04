// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:desi_shopping_seller/model/brand_model.dart';

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
  final int? offerPrice;
  bool? isBestSelling;
  final Timestamp createdAt = Timestamp.now();
  double rating;
  final BrandModel categoryBrand;
  final BrandModel realBrand;
  final List<String> imageUrl;
  final List<String> videoUrl;
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
    this.offerPrice,
    this.isBestSelling,
    required this.rating,
    required this.categoryBrand,
    required this.realBrand,
    required this.imageUrl,
    required this.videoUrl,
  });

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
      'offerPrice': offerPrice,
      'isBestSelling': isBestSelling,
      'rating': rating,
      'categoryBrand': categoryBrand.toMap(),
      'realBrand': realBrand.toMap(),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      sellerid: map['sellerid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      netVolume: map['netVolume'],
      dosage: map['dosage'],
      composition: map['composition'],
      storage: map['storage'],
      manufacturedBy: map['manufacturedBy'],
      marketedBy: map['marketedBy'],
      shelfLife: map['shelfLife'],
      additionalInformation: map['additionalInformation'],
      stock: map['stock'] ?? 0,
      taxAmount: (map['taxAmount'] ?? 0).toDouble(),
      cashOnDelivery: map['cashOnDelivery'] ?? 'No',
      offerPrice: map['offerPrice'],
      isBestSelling: map['isBestSelling'] ?? false,
      rating: (map['rating'] ?? 0).toDouble(),

      categoryBrand: BrandModel.fromMap(map['categoryBrand']),
      realBrand: BrandModel.fromMap(map['realBrand']),

      imageUrl: (map['imageUrl'] as List<dynamic>).cast<String>(),
      videoUrl: (map['videoUrl'] as List<dynamic>).cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, sellerid: $sellerid, title: $title, description: $description, price: $price, netVolume: $netVolume, dosage: $dosage, composition: $composition, storage: $storage, manufacturedBy: $manufacturedBy, marketedBy: $marketedBy, shelfLife: $shelfLife, additionalInformation: $additionalInformation, stock: $stock, taxAmount: $taxAmount, cashOnDelivery: $cashOnDelivery, offerPrice: $offerPrice, isBestSelling: $isBestSelling, rating: $rating, categoryBrand: $categoryBrand, realBrand: $realBrand, imageUrl: $imageUrl, videoUrl: $videoUrl)';
  }
}
