import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/rating_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  List<RatingModel> _allProductRating = [];
  List<RatingModel> _filteredProductRating = [];
  List<RatingModel> get allProductRating => _allProductRating;
  List<RatingModel> get allFilteredProductRating => _filteredProductRating;

  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("ratings");

  //get rating
  double _rating = 1.0;
  double get rating => _rating;

  void setRating(double value) {
    _rating = value;
    notifyListeners();
  }

  Future<List<RatingModel>> fetchRating({required BuildContext context}) async {
    try {
      final QuerySnapshot querySnapshot = await collectionReference.get();
      _allProductRating = querySnapshot.docs
          .map((doc) => RatingModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _filteredProductRating = _allProductRating;
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allProductRating;
  }

  void listenRating() {
    collectionReference.snapshots().listen((event) {
      _allProductRating = event.docs
          .map((doc) => RatingModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _filteredProductRating = _allProductRating;
      notifyListeners();
    });
  }

  Future<List<RatingModel>> filterReview({required String productId}) async {
    _filteredProductRating = _allProductRating
        .where((e) => e.productId == productId)
        .toList();
    return _filteredProductRating;
  }
}
