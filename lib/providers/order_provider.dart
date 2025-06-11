import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/order_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _allOrders = [];
  List<OrderModel> _filterOrders = [];
  List<OrderModel> get allOrders => _allOrders;
  List<OrderModel> get filterOrders => _filterOrders;

  List<int> getDashBoardContent(BuildContext context) {
    final products = context.read<ProductProvider>().allProduct.length;
    final brands = context.read<BrandProvider>().allBrands.length;
    final users = context.read<UserProvider>().allUsers.length;

    return [
      _allOrders
          .where((e) => e.createdAt.toDate().day == DateTime.now().day)
          .length,
      _allOrders
          .where(
            (e) =>
                e.createdAt.toDate().day == DateTime.now().day &&
                e.status == 'pending',
          )
          .length,
      _allOrders
          .where(
            (e) =>
                e.createdAt.toDate().day == DateTime.now().day &&
                e.status == 'delivered',
          )
          .length,
      _allOrders
          .where(
            (e) =>
                e.createdAt.toDate().day == DateTime.now().day &&
                e.status == 'cancelled',
          )
          .length,

      _allOrders.length,
      _allOrders.where((e) => e.status == 'pending').length,
      _allOrders.where((e) => e.status == 'delivered').length,
      _allOrders.where((e) => e.status == 'cancelled').length,

      products,
      brands,
      users,
    ];
  }

  //total orders
  int get totalOrders => _allOrders.length;

  Future<List<OrderModel>> getAllOrders({required BuildContext context}) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('customers')
          .doc()
          .collection('orders');
      final QuerySnapshot querySnapshot = await collectionReference.get();

      final orders = querySnapshot.docs
          .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      _allOrders = orders;
      _filterOrders = _allOrders;
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

  Future<List<OrderModel>> fetchIfNeeded({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('customers')
          .doc()
          .collection('orders');

      final orders = await collectionReference.get();

      if (orders.docs.length != _allOrders.length) {
        if (context.mounted) await getAllOrders(context: context);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    } catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    }
    return _allOrders;
  }
}
