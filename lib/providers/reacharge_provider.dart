import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/recharge_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RechargeProvider extends ChangeNotifier {
  final List<RechargeModel> _allRecharge = [];
  List<RechargeModel> get allRecharge => _allRecharge;

  List<RechargeModel> _filterRecharge = [];
  List<RechargeModel> get filterRecharge => _filterRecharge;

  final CollectionReference _rechargeRef = FirebaseFirestore.instance
      .collection('recharge');

  String? getCurrentUser() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<List<RechargeModel>> getAllRecharge({
    required BuildContext context,
  }) async {
    try {
      final snapshot = await _rechargeRef.get();
      _allRecharge.clear();
      _allRecharge.addAll(
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return RechargeModel.fromMap(data, id: doc.id);
        }).toList(),
      );

      _filterRecharge = List.from(_allRecharge);
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allRecharge;
  }

  Future<bool> addRechargePlan({
    required BuildContext context,
    required double price,
    required String dataInfo,
    required String validity,
    required String rechargeType,
    required String status,
  }) async {
    try {
      final docRef = _rechargeRef.doc();

      final RechargeModel model = RechargeModel(
        id: docRef.id,
        price: price,
        dataInfo: dataInfo,
        validity: validity,
        rechargeType: rechargeType,
        status: status,
        sellerId: getCurrentUser(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await docRef.set(model.toMap());
      _allRecharge.add(model);
      _filterRecharge = List.from(_allRecharge);
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> updateRechargePlan({
    required BuildContext context,
    required RechargeModel recharge,
    required double price,
    required String dataInfo,
    required String validity,
    required String rechargeType,
    required String status,
  }) async {
    try {
      final docRef = _rechargeRef.doc(recharge.id);

      final updatedModel = RechargeModel(
        id: recharge.id,
        sellerId: recharge.sellerId,
        customerId: recharge.customerId,
        price: price,
        dataInfo: dataInfo,
        validity: validity,
        rechargeType: rechargeType,
        status: status,
        createdAt: recharge.createdAt,
        updatedAt: Timestamp.now(),
      );

      await docRef.update(updatedModel.toMap());

      _allRecharge.removeWhere((e) => e.id == recharge.id);
      _allRecharge.add(updatedModel);
      _filterRecharge = _allRecharge;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> deleteRechargePlan({
    required BuildContext context,
    required String rechargeId,
  }) async {
    try {
      final docRef = _rechargeRef.doc(rechargeId);
      await docRef.delete();
      _allRecharge.removeWhere((e) => e.id == rechargeId);
      _filterRecharge = _allRecharge;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> updateStatus({
    required BuildContext context,
    required String rechargeId,
    required String status,
  }) async {
    try {
      final docRef = _rechargeRef.doc(rechargeId);
      await docRef.update({'status': status});
      _allRecharge.firstWhere((e) => e.id == rechargeId).status = status;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }
}
