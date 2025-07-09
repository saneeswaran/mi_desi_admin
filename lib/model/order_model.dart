import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String userId;
  final double totalAmount;
  final String address;
  final int phoneNumber;
  final double latitude;
  final double longitude;
  String orderStatus;
  final String orderDate;
  final String orderId;
  final Timestamp createdAt;
  final List<Map<String, dynamic>> products;

  OrderModel({
    required this.userId,
    required this.totalAmount,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.orderStatus,
    required this.orderDate,
    required this.orderId,
    required this.products,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'totalAmount': totalAmount,
    'address': address,
    'phoneNumber': phoneNumber,
    'latitude': latitude,
    'longitude': longitude,
    'orderStatus': orderStatus,
    'orderDate': orderDate,
    'orderId': orderId,
    'products': products,
    'createdAt': createdAt,
  };

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as int,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      orderStatus: map['orderStatus'] as String,
      orderDate: map['orderDate'] as String,
      orderId: map['orderId'] as String,
      createdAt: map['createdAt'] as Timestamp,
      products: List<Map<String, dynamic>>.from(map['products'] as List),
    );
  }
}
