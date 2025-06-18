import 'dart:convert';

import 'package:desi_shopping_seller/enum/app_enum.dart';

class PartnerModel {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String password;
  final PartnerStatus activeStatus;
  PartnerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.password,
    this.activeStatus = PartnerStatus.inactive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'password': password,
    };
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    return PartnerModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String,
      password: map['password'] as String,
      activeStatus: map['activeStatus'] as PartnerStatus,
    );
  }

  String toJson() => json.encode(toMap());

  factory PartnerModel.fromJson(String source) =>
      PartnerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
