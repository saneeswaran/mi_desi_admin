import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/referral_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class ReferralProvider extends ChangeNotifier {
  List<ReferralModel> _allReferral = [];
  List<ReferralModel> _filterReferral = [];
  List<ReferralModel> get allReferral => _allReferral;
  List<ReferralModel> get filterReferral => _filterReferral;

  //loaders
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<ReferralModel>> getAllReferrals({
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("referrals");
      final QuerySnapshot querySnapshot = await collectionReference.get();
      _allReferral = querySnapshot.docs
          .map((e) => ReferralModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      _filterReferral = _allReferral;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allReferral;
  }
}
