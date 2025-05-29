// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/product_model.dart';

class OrderModel {
  final String customerId;
  final String productId;
  final ProductModel product;
  final String orderId;
  final String status;
  final String address;
  final Timestamp createdAt = Timestamp.now();
  OrderModel({
    required this.customerId,
    required this.productId,
    required this.product,
    required this.orderId,
    required this.status,
    required this.address,
  });

  OrderModel copyWith({
    String? customerId,
    String? productId,
    ProductModel? product,
    String? orderId,
    String? status,
    String? address,
  }) {
    return OrderModel(
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerId': customerId,
      'productId': productId,
      'product': product.toMap(),
      'orderId': orderId,
      'status': status,
      'address': address,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      customerId: map['customerId'] as String,
      productId: map['productId'] as String,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      orderId: map['orderId'] as String,
      status: map['status'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(customerId: $customerId, productId: $productId, product: $product, orderId: $orderId, status: $status, address: $address)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.customerId == customerId &&
        other.productId == productId &&
        other.product == product &&
        other.orderId == orderId &&
        other.status == status &&
        other.address == address;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
        productId.hashCode ^
        product.hashCode ^
        orderId.hashCode ^
        status.hashCode ^
        address.hashCode;
  }
}
