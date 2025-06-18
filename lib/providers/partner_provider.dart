import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/partner_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerProvider extends ChangeNotifier {
  PartnerModel? _partner;
  PartnerModel? get partner => _partner;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection("partners");
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<bool> registerPartner({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required Uint8List imageBytes,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //get user uid
      final String uid = userCredential.user!.uid;

      // Upload image to Firebase Storage
      final ref = _firebaseStorage.ref().child("partner/$uid.jpg");
      final uploadTask = await ref.putData(imageBytes);
      final String partnerImageUrl = await uploadTask.ref.getDownloadURL();

      // Create partner model
      final PartnerModel partnerModel = PartnerModel(
        uid: uid,
        name: username,
        email: email,
        photoURL: partnerImageUrl,
        password: password,
      );

      // Save to Firestore
      await _collectionReference.doc(uid).set(partnerModel.toMap());

      // Save locally using SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('partner_email', email);
      prefs.setString('partner_uid', uid);
      prefs.setString('partner_name', username);
      prefs.setString('partner_photo', partnerImageUrl);

      _partner = partnerModel;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }

  Future<bool> partnerLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      //sign in with user email and password
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      //get user uid
      final String uid = userCredential.user!.uid;

      //get user data from firestore
      final DocumentSnapshot documentSnapshot = await _collectionReference
          .doc(uid)
          .get();

      //save locally using SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('partner_email', email);
      prefs.setString('partner_uid', uid);
      prefs.setString('partner_name', documentSnapshot['name']);
      prefs.setString('partner_photo', documentSnapshot['photoURL']);

      // save the details using from map
      _partner = PartnerModel.fromMap(
        documentSnapshot.data() as Map<String, dynamic>,
      );
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }
}
