import 'dart:convert';

class AdminModel {
  final String uid;
  final String name;
  final String email;
  final String? photoURL;
  final String password;
  final String? fcmToken;
  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
    this.fcmToken,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'password': password,
      'fcmToken': fcmToken,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] ?? '',
      password: map['password'] as String,
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
