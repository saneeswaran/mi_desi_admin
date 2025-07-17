import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/model/partner_model.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class PartnerProvider extends ChangeNotifier {
  //ref's
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection("partners");
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //------------------------
  PartnerModel? _partner;
  PartnerModel? get partner => _partner;

  //partner products
  List<ProductModel> _partnerProducts = [];
  List<ProductModel> get partnerProducts => _partnerProducts;

  // list of all partners
  List<PartnerModel> _allPartners = [];
  List<PartnerModel> get allPartners => _allPartners;

  List<PartnerModel> _filterPartners = [];
  List<PartnerModel> get filterPartners => _filterPartners;

  //loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ProductModel> _filterProducts = [];
  List<ProductModel> get filterproducts => _filterProducts;
  Future<bool> registerPartner({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      // Create user with email and password
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //get user uid
      final String uid = userCredential.user!.uid;

      // Create partner model
      final PartnerModel partnerModel = PartnerModel(
        uid: uid,
        name: username,
        email: email,
        password: password,
        activeStatus: "inactive",
      );

      // Save to Firestore
      await _collectionReference.doc(uid).set(partnerModel.toMap());

      _partner = partnerModel;
      _isLoading = false;
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
      _isLoading = true;
      //sign in with user email and password
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      //get user uid
      final String uid = userCredential.user!.uid;

      //get user data from firestore
      final DocumentSnapshot documentSnapshot = await _collectionReference
          .doc(uid)
          .get();

      // save the details using from map
      _partner = PartnerModel.fromMap(
        documentSnapshot.data() as Map<String, dynamic>,
      );
      _isLoading = false;
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

  Future<bool> partnerAddProduct({
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
    required BrandModel categoryBrand,
    required BrandModel realBrand,
    required String quantity,
    required List<File> imageFiles,
    required List<File> videoFiles,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final collectionReference = FirebaseFirestore.instance.collection(
        'products',
      );
      final docRef = collectionReference.doc();
      // Upload images
      List<String> imageUrls = [];
      for (File file in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = _firebaseStorage.ref().child('products/images/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Upload videos
      List<String> videoUrls = [];
      for (File file in videoFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = _firebaseStorage.ref().child('products/videos/$fileName');
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
        taxAmount: taxAmount,
        cashOnDelivery: cashOnDelivery,
        categoryBrand: categoryBrand,
        realBrand: realBrand,
        imageUrl: imageUrls,
        videoUrl: videoUrls,
        rating: 0.0,
      );

      await FirebaseFirestore.instance
          .collection('brands')
          .doc(categoryBrand.id)
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

  Future<List<ProductModel>> getPartnerAddedProductsOnly({
    required BuildContext context,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('products');
      final QuerySnapshot querySnapshot = await collectionReference
          .where("sellerid", isEqualTo: currentUser)
          .get();
      _partnerProducts = querySnapshot.docs
          .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      _filterProducts = _partnerProducts;
      notifyListeners();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return _partnerProducts;
  }

  Future<bool> partnerDeleteHisProduct({
    required BuildContext context,
    required ProductModel product,
  }) async {
    //for fast response
    _partnerProducts.removeWhere((e) => e.id == product.id);
    notifyListeners();
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot querySnapshot = await _collectionReference
          .where('sellerId', isEqualTo: currentUser)
          .where("id", isEqualTo: product.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        await _firebaseStorage
            .ref()
            .child('products/images/${product.id}')
            .delete();
        await _firebaseStorage
            .ref()
            .child('products/videos/${product.id}')
            .delete();
        return true;
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    } catch (e) {
      //for fallback
      _partnerProducts.add(product);
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
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
    required BrandModel categoryBrand,
    required BrandModel realBrand,
    required List<File> imageUrl,
    required List<File> videoUrl,
    required String netVolume,
    required String dosage,
    required String composition,
    required String storage,
    required String manufacturedBy,
    required String marketedBy,
    required String shelfLife,
    required int offerPrice,
    required String additionalInformation,
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
        final ref = _firebaseStorage.ref().child('products/images/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        uploadedImageUrls.add(downloadUrl);
      }

      // Upload new videos
      List<String> uploadedVideoUrls = [];
      for (File file in videoUrl) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
        final ref = _firebaseStorage.ref().child('products/videos/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        uploadedVideoUrls.add(downloadUrl);
      }
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
        categoryBrand: categoryBrand,
        realBrand: realBrand,
        rating: data['rating'] ?? 0.0,
        imageUrl: finalImageUrls,
        videoUrl: finalVideoUrls,
        additionalInformation: additionalInformation,
        composition: composition,
        dosage: dosage,
        manufacturedBy: manufacturedBy,
        marketedBy: marketedBy,
        netVolume: netVolume,
        offerPrice: offerPrice,
        shelfLife: shelfLife,
        storage: storage,
      );

      final int index = _partnerProducts.indexWhere(
        (element) => element.id == productId,
      );
      if (index != -1) {
        _partnerProducts[index] = productModel;
      } else {
        _partnerProducts.add(productModel);
      }

      await doc.reference.update(productModel.toMap());
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
      return false;
    }
  }

  Future<List<PartnerModel>> fetchAllPartners({
    required BuildContext context,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await _collectionReference.get();
      _allPartners = querySnapshot.docs
          .map((e) => PartnerModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      _filterPartners = _allPartners;

      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allPartners;
  }

  void filterByType({required String query}) {
    _filterPartners = _allPartners
        .where((e) => e.activeStatus.toLowerCase() == query.toLowerCase())
        .toList();
  }

  Future<bool> changePartnerStatus({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    try {
      setLoading(true);
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("partners");
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();

      if (documentSnapshot.exists) {
        await documentSnapshot.reference.update({"activeStatus": status});

        if (context.mounted) {
          await fetchAllPartners(context: context);
        }
        filterByType(query: status);

        setLoading(false);
        notifyListeners();
        return true;
      } else {
        if (context.mounted) {
          showSnackBar(context: context, e: "No such partner found");
        }
        setLoading(false);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        showSnackBar(context: context, e: e.toString());
      }
      return false;
    }
  }
}
