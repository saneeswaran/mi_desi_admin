import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filterProducts = [];

  List<ProductModel> get allProduct => _allProducts;
  List<ProductModel> get filterProduct => _filterProducts;

  //totals
  int get totalProductCounts => _allProducts.length;

  // Date filters
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Current brand filter
  String? _selectedBrandId;
  String? get selectedBrandId => _selectedBrandId;

  Future<bool> addProduct({
    required BuildContext context,
    required String title,
    required String description,
    required double price,
    required String netVolume,
    required String dosage,
    required String composition,
    required String storage,
    required String manufacturedBy,
    required String marketedBy,
    required String shelfLife,
    required String additionalInformation,
    required int stock,
    required double taxAmount,
    required String cashOnDelivery,
    required BrandModel brand,
    required int offerPrice,
    required List<File> imageFiles,
    required List<File> videoFiles,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final collectionReference = FirebaseFirestore.instance.collection(
        'products',
      );
      final docRef = collectionReference.doc();
      final FirebaseStorage storageCollection = FirebaseStorage.instance;

      // Upload images
      List<String> imageUrls = [];
      for (File file in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = storageCollection.ref().child('products/images/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Upload videos
      List<String> videoUrls = [];
      for (File file in videoFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = storageCollection.ref().child('products/videos/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        videoUrls.add(downloadUrl);
      }

      ProductModel productData = ProductModel(
        id: docRef.id,
        sellerid: currentUser,
        title: title,
        description: description,
        price: price,
        netVolume: netVolume,
        dosage: dosage,
        composition: composition,
        storage: storage,
        manufacturedBy: manufacturedBy,
        marketedBy: marketedBy,
        shelfLife: shelfLife,
        additionalInformation: additionalInformation,
        stock: stock,
        offerPrice: offerPrice,
        taxAmount: taxAmount,
        cashOnDelivery: cashOnDelivery,
        brand: brand,
        imageUrl: imageUrls,
        videoUrl: videoUrls,
        rating: 0.0,
      );

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brand.id)
          .update({'productsCount': FieldValue.increment(1)});

      await docRef.set(productData.toMap());

      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
      return false;
    }
  }

  Future<List<ProductModel>> getSellerProducts({
    required BuildContext context,
  }) async {
    try {
      final collectionReference = FirebaseFirestore.instance.collection(
        'products',
      );

      final querySnapshot = await collectionReference.get();

      _allProducts = querySnapshot.docs
          .map((e) => ProductModel.fromMap(e.data()))
          .toList();

      _filterProducts = List.from(_allProducts);

      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allProducts;
  }

  Future<bool> deleteProduct({
    required BuildContext context,
    required String productId,
    required String brandId,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final collectionReference = FirebaseFirestore.instance.collection(
        'products',
      );

      final querySnapshot = await collectionReference
          .where('sellerid', isEqualTo: currentUser)
          .where('id', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isNotEmpty && context.mounted) {
        final banner = Provider.of<BannersProvider>(
          context,
          listen: false,
        ).allBanners;

        final bool bannerHasProduct = banner.any(
          (e) => e.productId == productId,
        );

        if (bannerHasProduct && context.mounted) {
          showSnackBar(
            context: context,
            e: "Product have banner.Please remove banner first.",
          );
        } else {
          await querySnapshot.docs.first.reference.delete();

          await FirebaseFirestore.instance
              .collection('brands')
              .doc(brandId)
              .update({'productsCount': FieldValue.increment(-1)});
          _allProducts.removeWhere((element) => element.id == productId);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return false;
  }

  Future<bool> updateProduct({
    required BuildContext context,
    required String productId,
    required String title,
    required String description,
    required double price,
    required int stock,
    required double taxAmount,
    required String cashOnDelivery,
    required BrandModel brand,
    required int offerPrice,
    required String netVolume,
    required String dosage,
    required String composition,
    required String storage,
    required String manufacturedBy,
    required String marketedBy,
    required String shelfLife,
    required String additionalInformation,
    required List<File> imageUrl,
    required List<File> videoUrl,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final collectionReference = FirebaseFirestore.instance.collection(
        'products',
      );
      final firebaseStorage = FirebaseStorage.instance;

      final querySnapshot = await collectionReference
          .where('sellerid', isEqualTo: currentUser)
          .where('id', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isEmpty) return false;

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      List<String> existingImageUrls = List<String>.from(
        data['imageUrl'] ?? [],
      );
      List<String> existingVideoUrls = List<String>.from(
        data['videoUrl'] ?? [],
      );

      // Upload new images
      List<String> uploadedImageUrls = [];
      for (File file in imageUrl) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = firebaseStorage.ref().child('products/images/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        uploadedImageUrls.add(downloadUrl);
      }

      // Upload new videos
      List<String> uploadedVideoUrls = [];
      for (File file in videoUrl) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = firebaseStorage.ref().child('products/videos/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        uploadedVideoUrls.add(downloadUrl);
      }

      // Combine old + new (or only old if new is empty)
      final finalImageUrls = imageUrl.isEmpty
          ? existingImageUrls
          : uploadedImageUrls;
      final finalVideoUrls = videoUrl.isEmpty
          ? existingVideoUrls
          : uploadedVideoUrls;

      ProductModel productModel = ProductModel(
        id: productId,
        sellerid: currentUser,
        title: title,
        description: description,
        price: price,
        stock: stock,
        taxAmount: taxAmount,
        cashOnDelivery: cashOnDelivery,
        brand: brand,
        rating: data['rating'] ?? 0.0,
        imageUrl: finalImageUrls,
        videoUrl: finalVideoUrls,
        additionalInformation: additionalInformation,
        composition: composition,
        dosage: dosage,
        manufacturedBy: manufacturedBy,
        marketedBy: marketedBy,
        netVolume: netVolume,
        shelfLife: shelfLife,
        offerPrice: offerPrice,
        storage: storage,
      );

      final int index = _allProducts.indexWhere(
        (element) => element.id == productId,
      );
      if (index != -1) {
        _allProducts[index] = productModel;
      } else {
        _allProducts.add(productModel);
      }

      await doc.reference.update(productModel.toMap());
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
      return false;
    }
  }

  Future<List<ProductModel>> fetchIfNeeded({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('products');

      final allProducts = await collectionReference.get();

      if (allProducts.docs.length != _allProducts.length) {
        if (context.mounted) await getSellerProducts(context: context);
      } else {
        return _allProducts;
      }
    } on FirebaseException catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return _allProducts;
  }

  Future<bool> bannerOfferValueUpdate({
    required BuildContext context,
    required String productId,
    required int offerPrice,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('products');
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(productId)
          .get();
      await documentSnapshot.reference.update({'offerPrice': offerPrice});
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return false;
  }

  Future<List<ProductModel>> filter({required String query}) async {
    _filterProducts = _allProducts
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
    return _filterProducts;
  }

  void filterByDate(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;

    _filterProducts = _allProducts.where((element) {
      final date = element.createdAt.toDate();
      return date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    notifyListeners();
  }

  void filterByBrand(String? brandId) {
    _selectedBrandId = brandId;

    if (brandId == null || brandId.isEmpty) {
      _filterProducts = List.from(_allProducts);
    } else {
      _filterProducts = _allProducts
          .where((product) => product.brand.id == brandId)
          .toList();
    }

    notifyListeners();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _startDate = picked;
      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = null;
      }
      if (_startDate != null && _endDate != null) {
        filterByDate(_startDate!, _endDate!);
      }
      notifyListeners();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (_startDate == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _endDate = picked;
      if (_startDate != null && _endDate != null) {
        filterByDate(_startDate!, _endDate!);
      }
      notifyListeners();
    }
  }

  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _selectedBrandId = null;
    _filterProducts = List.from(_allProducts);
    notifyListeners();
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy, hh:mm a').format(date);
  }
}
