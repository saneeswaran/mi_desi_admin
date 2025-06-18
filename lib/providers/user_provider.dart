import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/customer_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<CustomerModel> _allUsers = [];
  List<CustomerModel> _filterUsers = [];
  List<CustomerModel> get allUsers => _allUsers;

  List<CustomerModel> get filterUsers => _filterUsers;

  Future<List<CustomerModel>> getAllUsers({
    required BuildContext context,
  }) async {
    try {
      final collectionReference = FirebaseFirestore.instance.collection(
        'customers',
      );

      final QuerySnapshot querySnapshot = await collectionReference.get();

      final users = querySnapshot.docs
          .map((e) => CustomerModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      _allUsers = users;
      _filterUsers = List.from(_allUsers);
      notifyListeners();
    } on FirebaseException catch (e) {
      log("user provider error");
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
      log("user provider error");
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allUsers;
  }

  void filter({required String query}) {
    _filterUsers = _allUsers
        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
