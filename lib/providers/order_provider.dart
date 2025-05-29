import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<ProductModel> _allOrders = [];
  List<ProductModel> _filterOrders = [];

  List<ProductModel> get allOrders => _allOrders;
  List<ProductModel> get filterOrders => _filterOrders;

  int get totalOrders => _allOrders.length;

  Future<List<ProductModel>> getAllOrders({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('customers')
          .doc()
          .collection('orders');

      final QuerySnapshot querySnapshot = await collectionReference.get();

      final product = querySnapshot.docs.map((e) {
        final productId = e.get('id');
        return ProductModel.fromMap(productId);
      }).toList();

      _allOrders = product;
      _filterOrders = List.from(_allOrders);
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
    return _allOrders;
  }
}
