import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String userId;
  final double totalAmount;
  final String address;
  final int phoneNumber;
  final double latitude;
  final double longitude;
  final String orderStatus;
  final String orderDate;
  final String orderId;
  final Timestamp createdAt = Timestamp.now();

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
  });

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'],
      totalAmount: map['totalAmount'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      orderStatus: map['orderStatus'],
      orderDate: map['orderDate'],
      orderId: map['orderId'],
      products: List<Map<String, dynamic>>.from(map['products']),
    );
  }
}
