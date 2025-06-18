import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/user_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviders extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('customers');

  User? _user;
  UserModel? _userModel;

  User? get user => _user;
  UserModel? get userData => _userModel;

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      _user = userCredential.user;

      final doc = await _userCollection.doc(_user!.uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.message ?? 'Login failed');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: 'Something went wrong');
      }
    }
  }

  Future<bool> registerUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      _user = userCredential.user;
      _userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
      );

      await _userCollection.doc(uid).set(_userModel!.toMap());
      log(_userModel!.toMap().toString());
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.message ?? 'Registration failed');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: 'Something went wrong');
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  void listenToAuthState() {
    _auth.authStateChanges().listen((firebaseUser) async {
      _user = firebaseUser;
      if (_user != null) {
        final doc = await _userCollection.doc(_user!.uid).get();
        if (doc.exists) {
          _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }
}
