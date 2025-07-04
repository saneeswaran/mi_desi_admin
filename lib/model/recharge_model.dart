// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RechargeModel {
  final String? id;
  final String? sellerId;
  final String? customerId;
  final double price;
  final String dataInfo;
  final String validity;
  final String rechargeProvider;
  String? status;
  final Timestamp? createdAt = Timestamp.now();
  RechargeModel({
    this.id,
    this.sellerId,
    this.customerId,
    required this.price,
    required this.dataInfo,
    required this.validity,
    required this.rechargeProvider,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sellerId': sellerId,
      'customerId': customerId,
      'price': price,
      'dataInfo': dataInfo,
      'validity': validity,
      'rechargeProvider': rechargeProvider,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory RechargeModel.fromMap(Map<String, dynamic> map) {
    return RechargeModel(
      id: map['id'] != null ? map['id'] as String : null,
      sellerId: map['sellerId'] != null ? map['sellerId'] as String : null,
      customerId: map['customerId'] != null
          ? map['customerId'] as String
          : null,
      price: map['price'] as double,
      dataInfo: map['dataInfo'] as String,
      validity: map['validity'] as String,
      rechargeProvider: map['rechargeProvider'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RechargeModel.fromJson(String source) =>
      RechargeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RechargeModel(id: $id, sellerId: $sellerId, customerId: $customerId, price: $price, dataInfo: $dataInfo, validity: $validity, rechargeProvider: $rechargeProvider, status: $status)';
  }
}

class RechargeProvider {
  final String id;
  final String image;
  final String providerName;
  RechargeProvider({
    required this.id,
    required this.image,
    required this.providerName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'providerName': providerName,
    };
  }

  factory RechargeProvider.fromMap(Map<String, dynamic> map) {
    return RechargeProvider(
      id: map['id'] as String,
      image: map['image'] as String,
      providerName: map['providerName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RechargeProvider.fromJson(String source) =>
      RechargeProvider.fromMap(json.decode(source) as Map<String, dynamic>);
}
