// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:desi_shopping_seller/enum/app_enum.dart';

class PartnerModel {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String activeStatus;
  PartnerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    this.activeStatus = "inactive",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'activeStatus': partnerStatusToString(PartnerStatus.inactive),
    };
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    return PartnerModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      activeStatus: map['activeStatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PartnerModel.fromJson(String source) =>
      PartnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PartnerModel(uid: $uid, name: $name, email: $email, password: $password, activeStatus: $activeStatus)';
  }
}
