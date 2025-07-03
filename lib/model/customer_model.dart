// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String? uid;
  final String name;
  final String email;
  final String? imageUrl;
  final String? customerReferalCode;
  final String? usedReferralCode;
  final String? fcmToken;
  CustomerModel({
    this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    this.customerReferalCode,
    this.usedReferralCode,
    this.fcmToken,
  });
  final Timestamp lastLogin = Timestamp.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'customerReferalCode': customerReferalCode,
      'usedReferralCode': usedReferralCode,
      'fcmToken': fcmToken,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      customerReferalCode: map['customerReferalCode'] != null
          ? map['customerReferalCode'] as String
          : null,
      usedReferralCode: map['usedReferralCode'] != null
          ? map['usedReferralCode'] as String
          : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
