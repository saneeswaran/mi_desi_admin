import 'package:cloud_firestore/cloud_firestore.dart';

class RechargeModel {
  final String? id;
  final String? sellerId;
  final String? customerId;
  final double price;
  final String dataInfo;
  final String validity;
  final String rechargeType;
  String status;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  RechargeModel({
    this.id,
    this.sellerId,
    this.customerId,
    required this.price,
    required this.dataInfo,
    required this.validity,
    required this.rechargeType,
    required this.status,
    Timestamp? createdAt,
    required this.updatedAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  /// Convert Firestore document to model
  factory RechargeModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return RechargeModel(
      id: id,
      sellerId: map['sellerId'],
      customerId: map['customerId'],
      price: (map['price'] as num).toDouble(),
      dataInfo: map['dataInfo'] ?? '',
      validity: map['validity'] ?? '',
      rechargeType: map['rechargeType'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'customerId': customerId,
      'price': price,
      'dataInfo': dataInfo,
      'validity': validity,
      'rechargeType': rechargeType,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
