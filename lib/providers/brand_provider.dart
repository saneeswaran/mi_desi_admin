import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class BrandProvider extends ChangeNotifier {
  List<BrandModel> _allBrands = [];
  List<BrandModel> _filterBrands = [];

  List<BrandModel> get allBrands => _allBrands;
  List<BrandModel> get filterBrands => _filterBrands;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void switchTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<bool> addBrand({
    required BuildContext context,
    required String title,
    required File imageFile,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('brands').doc();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final ref = FirebaseStorage.instance.ref().child('brands/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      final brandModel = BrandModel(
        id: docRef.id,
        sellerId: currentUser,
        title: title,
        imageUrl: downloadUrl,
        productsCount: 0,
      );

      await docRef.set(brandModel.toMap());

      _allBrands.add(brandModel);
      _filterBrands = _allBrands;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  Future<List<BrandModel>> getBrands({required BuildContext context}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .get();
      _allBrands = querySnapshot.docs
          .map((e) => BrandModel.fromMap(e.data()))
          .toList();
      _filterBrands = List.from(_allBrands);

      notifyListeners();
    } catch (e) {
      if (context.mounted) _showError(context, e);
    }
    return _allBrands;
  }

  Future<bool> deleteBrand({
    required BuildContext context,
    required String brandId,
  }) async {
    try {
      final hasProducts = await FirebaseFirestore.instance
          .collection('products')
          .where('brand.id', isEqualTo: brandId)
          .get();

      if (hasProducts.docs.isNotEmpty) {
        if (context.mounted) {
          _showMessage(
            context,
            'You cannot delete this brand because it is used in some products.',
          );
        }
        return false;
      }

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .delete();
      await FirebaseStorage.instance
          .refFromURL(
            _allBrands.firstWhere((element) => element.id == brandId).imageUrl,
          )
          .delete();

      _allBrands.removeWhere((element) => element.id == brandId);
      _filterBrands.removeWhere((element) => element.id == brandId);

      notifyListeners();
      if (context.mounted) {
        _showMessage(context, 'Brand deleted successfully');
      }
      return true;
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  Future<bool> updateBrand({
    required BuildContext context,
    required String brandId,
    required String title,
    required String imageUrl, // can be a URL or local path
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;

      String finalImageUrl = imageUrl;

      final isLocalImage = !imageUrl.startsWith(
        'http',
      ); // check if it's a new file

      if (isLocalImage) {
        final file = File(imageUrl);
        if (file.existsSync()) {
          final storageRef = FirebaseStorage.instance.ref().child(
            'brands/${DateTime.now().millisecondsSinceEpoch}',
          );
          final uploadTask = await storageRef.putFile(file);
          finalImageUrl = await uploadTask.ref.getDownloadURL();
        } else {
          throw 'Selected image file does not exist';
        }
      }

      final brandModel = BrandModel(
        id: brandId,
        sellerId: currentUser,
        title: title,
        imageUrl: finalImageUrl,
      );

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .update(brandModel.toMap());

      final index = _allBrands.indexWhere((element) => element.id == brandId);
      if (index != -1) _allBrands[index] = brandModel;

      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  Future<List<BrandModel>> filterBrandsByQuery({required String query}) async {
    _filterBrands = _allBrands
        .where(
          (element) =>
              element.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    notifyListeners();
    return _filterBrands;
  }

  void _showMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showError(BuildContext context, Object error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
