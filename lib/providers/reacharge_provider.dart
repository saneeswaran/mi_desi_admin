import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/recharge_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ReachargesProvider extends ChangeNotifier {
  List<RechargeModel> _allRecharge = [];
  List<RechargeModel> get allRecharge => _allRecharge;

  List<RechargeModel> _filterRecharge = [];
  List<RechargeModel> get filterRecharge => _filterRecharge;

  //loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //del loading

  bool _delLoading = false;
  bool get delLoading => _delLoading;
  void setDelLoading(bool value) {
    _delLoading = value;
    notifyListeners();
  }

  //ref
  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('recharge');

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<List<RechargeModel>> getAllRechargeModel({
    required BuildContext context,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await collectionReference.get();
      _allRecharge = querySnapshot.docs
          .map((e) => RechargeModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      _filterRecharge = _allRecharge;
      notifyListeners();
      return _allRecharge;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allRecharge;
  }

  Future<bool> createRechargePlan({
    required BuildContext context,
    required double price,
    required String dataInfo,
    required String validity,
    required String rechargeProvider,
    required String status,
  }) async {
    try {
      setLoading(true);
      final docRef = collectionReference.doc();

      final RechargeModel rechargeModel = RechargeModel(
        id: docRef.id,
        price: price,
        dataInfo: dataInfo,
        validity: validity,
        rechargeProvider: rechargeProvider,
        status: status,
      );
      await docRef.set(rechargeModel.toMap());
      _allRecharge.add(rechargeModel);
      _filterRecharge = _allRecharge;
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> updateRechargePlan({
    required BuildContext context,
    required String id,
    required double price,
    required String dataInfo,
    required String validity,
    required String rechargeProvider,
    required String status,
  }) async {
    try {
      setLoading(true);

      final RechargeModel rechargeModel = RechargeModel(
        id: id,
        price: price,
        dataInfo: dataInfo,
        validity: validity,
        rechargeProvider: rechargeProvider,
        status: status,
      );
      await collectionReference.doc(id).update(rechargeModel.toMap());
      final int index = _allRecharge.indexWhere((element) => element.id == id);
      if (index != -1) {
        _allRecharge[index] = rechargeModel;
        _filterRecharge = List.from(_allRecharge);
      }

      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }

  Future<bool> removePlan({
    required BuildContext context,
    required String id,
  }) async {
    try {
      setDelLoading(true);
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();
      await documentSnapshot.reference.delete();
      _allRecharge.removeWhere((e) => e.id == id);
      _filterRecharge = _allRecharge;
      setDelLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setDelLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }

  void filterByName({required String query}) {
    _filterRecharge = _allRecharge
        .where(
          (e) => e.rechargeProvider.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

class RechargeSimProvider extends ChangeNotifier {
  List<RechargeProvider> _allProvider = [];
  List<RechargeProvider> get allProvider => _allProvider;

  List<RechargeProvider> _filterProvider = [];
  List<RechargeProvider> get filterProvider => _filterProvider;

  //ref
  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('rechargeProvider');
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  //loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //update loading state
  bool _isUpdateLoading = false;
  bool get isUpdateLoading => _isUpdateLoading;
  void updateLoading(bool value) {
    _isUpdateLoading = value;
    notifyListeners();
  }

  Future<bool> getAllProvider({required BuildContext context}) async {
    try {
      setLoading(true);
      final QuerySnapshot querySnapshot = await collectionReference.get();
      _allProvider = querySnapshot.docs
          .map(
            (e) => RechargeProvider.fromMap(e.data() as Map<String, dynamic>),
          )
          .toList();
      _filterProvider = _allProvider;
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }

  Future<bool> createProvider({
    required BuildContext context,
    required File image,
    required String providerName,
  }) async {
    try {
      setLoading(true);
      final docRef = collectionReference.doc();
      final ref = firebaseStorage.ref().child('recharge/${docRef.id}');
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();
      final RechargeProvider rechargeProvider = RechargeProvider(
        id: docRef.id,
        image: imageUrl,
        providerName: providerName,
      );
      await docRef.set(rechargeProvider.toMap());
      _allProvider.add(rechargeProvider);
      _filterProvider = _allProvider;
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> deleteProvider({
    required BuildContext context,
    required String id,
  }) async {
    try {
      setLoading(true);
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();
      firebaseStorage.ref().child('recharge/$id').delete();
      await documentSnapshot.reference.delete();
      _allProvider.removeWhere((e) => e.id == id);
      _filterProvider = _allProvider;
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> updateRecharge({
    required BuildContext context,
    required String id,
    required String providerName,
    required File image,
  }) async {
    try {
      updateLoading(true);
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();
      final ref = firebaseStorage.ref().child('recharge/$id');
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();
      final RechargeProvider rechargeProvider = RechargeProvider(
        id: id,
        image: imageUrl,
        providerName: providerName,
      );
      final int index = _allProvider.indexWhere((e) => e.id == id);
      if (index != -1) {
        _allProvider[index] = rechargeProvider;
        _filterProvider = _allProvider;
      }
      await documentSnapshot.reference.update(rechargeProvider.toMap());
      updateLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      updateLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }
}
