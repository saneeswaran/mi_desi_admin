import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserAddressModel {
  final String id;
  final String userId;
  final String name;
  final int phoneNumber;
  final String email;
  final int pincode;
  final String address;
  double latitude;
  double longitude;
  UserAddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.pincode,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'pincode': pincode,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as int,
      email: map['email'] as String,
      pincode: map['pincode'] as int,
      address: map['address'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddressModel.fromJson(String source) =>
      UserAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
