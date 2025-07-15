import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/admin_model.dart';
import 'package:desi_shopping_seller/model/partner_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthProviders extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('admins');

  User? _user;
  AdminModel? _userModel;

  User? get user => _user;
  AdminModel? get userData => _userModel;

  //partner model
  PartnerModel? _currentUser;
  PartnerModel? get currentUser => _currentUser;

  Future<bool> loginAdmin({
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
        _userModel = AdminModel.fromMap(doc.data() as Map<String, dynamic>);

        final fcmToken = await FirebaseMessaging.instance.getToken();

        await _userCollection.doc(_user!.uid).update({'fcmToken': fcmToken});

        notifyListeners();
        return true;
      } else {
        if (context.mounted) {
          showSnackBar(context: context, e: 'Admin account not found');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.message ?? 'Login failed');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: 'Something went wrong');
      }
    }

    return false;
  }

  Future<bool> registerAdmin({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // Create account
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      // Get FCM Token
      final fcmToken = await FirebaseMessaging.instance.getToken();

      // Create admin model
      final adminModel = AdminModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      // Save to Firestore
      await firestore.collection('admins').doc(uid).set(adminModel.toMap());

      // Show success
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin Registered Successfully")),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
      }
      return false;
    }
  }

  Future<bool> logout() async {
    await _auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
    return true;
  }

  Future<PartnerModel> getCurrentUserDetails({
    required BuildContext context,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("partners");
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(currentUser)
          .get();

      if (documentSnapshot.exists) {
        _currentUser = PartnerModel.fromMap(
          documentSnapshot.data()! as Map<String, dynamic>,
        );
        log(_currentUser.toString());
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.toString());
      }
    }
    return _currentUser!;
  }

  Future<bool> resetPartnerPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      //reset  password
      final auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.toString());
        return false;
      }
    }
    return false;
  }
}
