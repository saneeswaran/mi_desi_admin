import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String ratingId;
  final String userId;
  final String userName;
  final String productId;
  final double rating;
  final String comment;
  final Timestamp createdAt;

  RatingModel({
    required this.ratingId,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'ratingId': ratingId,
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      ratingId: map['ratingId'],
      userId: map['userId'],
      userName: map['userName'],
      productId: map['productId'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      createdAt: map['createdAt'],
    );
  }
}
