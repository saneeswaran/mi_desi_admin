import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class BrandProvider extends ChangeNotifier {
  List<BrandModel> _allBrands = [];
  List<BrandModel> _filteredBrands = [];

  List<BrandModel> get allBrands => _allBrands;
  List<BrandModel> get filteredBrands => _filteredBrands;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  //brand
  BrandModel? _selectedBrand;
  BrandModel? get selectedBrand => _selectedBrand;

  void changeSelectedBrand(BrandModel? brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw 'User not authenticated';

      final docRef = FirebaseFirestore.instance.collection('brands').doc();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final ref = FirebaseStorage.instance.ref().child('brands/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      final brandModel = BrandModel(
        id: docRef.id,
        sellerId: currentUser.uid,
        title: title,
        imageUrl: downloadUrl,
        productsCount: 0,
      );

      await docRef.set(brandModel.toMap());

      _allBrands.add(brandModel);
      _filteredBrands = List.from(_allBrands);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Add Brand Error: $e');
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  Future<List<BrandModel>> getBrands({required BuildContext context}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw 'User not authenticated';

      final querySnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .get();

      _allBrands = querySnapshot.docs
          .map((e) => BrandModel.fromMap(e.data()))
          .toList();

      _filteredBrands = _allBrands;
      notifyListeners();
    } catch (e) {
      debugPrint('Get Brands Error: $e');
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
            'Cannot delete brand — it is used in some products.',
          );
        }
        return false;
      }

      final imageUrl = _allBrands
          .firstWhere((element) => element.id == brandId)
          .imageUrl;

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .delete();
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      _allBrands.removeWhere((element) => element.id == brandId);
      _filteredBrands.removeWhere((element) => element.id == brandId);

      notifyListeners();

      if (context.mounted) {
        _showMessage(context, 'Brand deleted successfully');
      }
      return true;
    } catch (e) {
      debugPrint('Delete Brand Error: $e');
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  Future<bool> updateBrand({
    required BuildContext context,
    required String brandId,
    required String title,
    required String imageUrl,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw 'User not authenticated';

      String finalImageUrl = imageUrl;

      final isLocalImage = !imageUrl.startsWith('http');

      if (isLocalImage) {
        final file = File(imageUrl);
        if (file.existsSync()) {
          final fileName =
              '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
          final ref = FirebaseStorage.instance.ref().child('brands/$fileName');
          await ref.putFile(file);
          finalImageUrl = await ref.getDownloadURL();
        } else {
          throw 'Selected image file does not exist';
        }
      }

      final brandModel = BrandModel(
        id: brandId,
        sellerId: currentUser.uid,
        title: title,
        imageUrl: finalImageUrl,
        productsCount: _allBrands
            .firstWhere((element) => element.id == brandId)
            .productsCount,
      );

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .update(brandModel.toMap());

      final index = _allBrands.indexWhere((element) => element.id == brandId);
      if (index != -1) _allBrands[index] = brandModel;

      _filteredBrands = _allBrands;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update Brand Error: $e');
      if (context.mounted) _showError(context, e);
      return false;
    }
  }

  void filterBrandsByQuery(String query) {
    _filteredBrands = _allBrands
        .where(
          (element) =>
              element.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    notifyListeners();
  }

  void decrementProductCountForBrand(String brandId) {
    final index = _allBrands.indexWhere((element) => element.id == brandId);
    if (index != -1) {
      _allBrands[index].productsCount = (_allBrands[index].productsCount - 1)
          .clamp(0, 9999);
      notifyListeners();
    }
  }

  //please do not modify this

  Future<List<BrandModel>> fetchIfNeeded({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('brands');

      final brandsList = await collectionReference.get();

      if (brandsList.docs.length != _allBrands.length) {
        if (context.mounted) await getBrands(context: context);
      } else {
        return _allBrands;
      }
    } on FirebaseException catch (e) {
      if (context.mounted) _showError(context, e);
    } catch (e) {
      if (context.mounted) _showError(context, e);
    }
    return _allBrands;
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
