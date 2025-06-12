import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/banner_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BannersProvider extends ChangeNotifier {
  List<BannerModel> _allBanners = [];
  List<BannerModel> _filterBanners = [];
  List<BannerModel> get allBanners => _allBanners;
  List<BannerModel> get filterBanners => _filterBanners;
  Future<List<BannerModel>> fetchBanners({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('banners');
      final QuerySnapshot querySnapshot = await collectionReference.get();

      final data = querySnapshot.docs.map((e) => e.data()).toList();
      _allBanners = data
          .map((e) => BannerModel.fromMap(e as Map<String, dynamic>))
          .toList();
      _filterBanners = _allBanners;
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
    return _allBanners;
  }

  Future<bool> addBanners({
    required BuildContext context,
    required String productId,
    required File image,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('banners');
      final docRef = collectionReference.doc();
      final FirebaseStorage storage = FirebaseStorage.instance;
      final ref = storage.ref().child('banners/$productId');
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();

      // add banner
      final BannerModel bannerModel = BannerModel(
        imageUrl: downloadUrl,
        productId: productId,
        bannerId: docRef.id,
      );
      await docRef.set(bannerModel.toMap());
      _allBanners.add(bannerModel);
      _filterBanners = _allBanners;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> deleteBanner({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('banners');
      final storage = FirebaseStorage.instance;
      final querySnapshot = await collectionReference.doc(productId).get();

      if (querySnapshot.exists) {
        await querySnapshot.reference.delete();
        await storage.ref().child('banners/$productId').delete();
        _allBanners.removeWhere((e) => e.productId == productId);
        _filterBanners = _allBanners;
        return true;
      }
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
    return false;
  }

  Future<bool> updateBanners({
    required BuildContext context,
    required String productId,
    required File image,
    required int offerPrice,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('banners');
      final CollectionReference productCollection = FirebaseFirestore.instance
          .collection('products');
      final storage = FirebaseStorage.instance;
      final QuerySnapshot querySnapshot = await collectionReference
          .where('productId', isEqualTo: productId)
          .get();
      final task = await storage
          .ref()
          .child('banners/$productId')
          .putFile(image);
      final downloadUrl = await task.ref.getDownloadURL();

      final newData = BannerModel(
        bannerId: collectionReference.doc(productId).id,
        imageUrl: downloadUrl,
        productId: productId,
      );

      await productCollection.doc(productId).update({'offerPrice': offerPrice});

      final newBannerSnapshot = querySnapshot.docs.where(
        (e) => e['productId'] == productId,
      );
      await newBannerSnapshot.first.reference.update(newData.toMap());
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<List<BannerModel>> fetchIfNeeded({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('banners');

      final QuerySnapshot querySnapshot = await collectionReference.get();

      if (querySnapshot.docs.length != _allBanners.length) {
        if (context.mounted) await fetchBanners(context: context);
      } else {
        return _allBanners;
      }
    } on FirebaseException catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return _allBanners;
  }
}
