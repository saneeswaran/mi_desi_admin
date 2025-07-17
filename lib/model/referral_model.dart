import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralModel {
  final String referredBy;
  final String referredTo;
  final Timestamp referredAt;

  ReferralModel({
    required this.referredBy,
    required this.referredTo,
    required this.referredAt,
  });

  Map<String, dynamic> toMap() => {
    'referredBy': referredBy,
    'referredTo': referredTo,
    'referredAt': referredAt,
  };

  factory ReferralModel.fromMap(Map<String, dynamic> map) {
    return ReferralModel(
      referredBy: map['referredBy'],
      referredTo: map['referredTo'],
      referredAt: map['referredAt'],
    );
  }
}
