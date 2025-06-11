// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/product_model.dart';

class OrderModel {
  final String userId;
  final String sellerId;
  final double totalAmount;
  final String address;
  final String paymentMethod;
  final String orderStatus;
  final String isShowCashOnDelivery;
  final String orderDate;
  final String orderId;
  final Timestamp timestamp;
  final List<ProductModel> product;
  final createdAt = Timestamp.now();
  OrderModel({
    required this.userId,
    required this.sellerId,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.orderStatus,
    required this.isShowCashOnDelivery,
    required this.orderDate,
    required this.orderId,
    required this.timestamp,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'sellerId': sellerId,
      'totalAmount': totalAmount,
      'address': address,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'isShowCashOnDelivery': isShowCashOnDelivery,
      'orderDate': orderDate,
      'orderId': orderId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'product': product.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] as String,
      sellerId: map['sellerId'] as String,
      totalAmount: map['totalAmount'] as double,
      address: map['address'] as String,
      paymentMethod: map['paymentMethod'] as String,
      orderStatus: map['orderStatus'] as String,
      isShowCashOnDelivery: map['isShowCashOnDelivery'] as String,
      orderDate: map['orderDate'] as String,
      orderId: map['orderId'] as String,
      timestamp: map['timestamp'] as Timestamp,
      product: List<ProductModel>.from(
        (map['products'] as List<int>).map<ProductModel>(
          (x) => ProductModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  get status => null;
}
