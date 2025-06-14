import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
