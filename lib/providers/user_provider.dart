import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/user_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _allUsers = [];
  List<UserModel> _filterUsers = [];
  List<UserModel> get allUsers => _allUsers;

  List<UserModel> get filterUsers => _filterUsers;

  Future<List<UserModel>> getAllUsers({required BuildContext context}) async {
    try {
      final collectionReference = FirebaseFirestore.instance.collection(
        'customers',
      );

      final QuerySnapshot querySnapshot = await collectionReference.get();

      final users = querySnapshot.docs
          .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      _allUsers = users;
      _filterUsers = List.from(_allUsers);
      notifyListeners();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
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
