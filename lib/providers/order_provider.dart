import 'dart:developer';

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
                e.orderStatus == 'pending',
          )
          .length,
      _allOrders
          .where(
            (e) =>
                e.createdAt.toDate().day == DateTime.now().day &&
                e.orderStatus == 'delivered',
          )
          .length,
      _allOrders
          .where(
            (e) =>
                e.createdAt.toDate().day == DateTime.now().day &&
                e.orderStatus == 'cancelled',
          )
          .length,

      _allOrders.length,
      _allOrders.where((e) => e.orderStatus == 'pending').length,
      _allOrders.where((e) => e.orderStatus == 'delivered').length,
      _allOrders.where((e) => e.orderStatus == 'cancelled').length,

      products,
      brands,
      users,
    ];
  }

  //total orders
  int get totalOrders => _allOrders.length;

  List<String> allOrderStatus = [
    'Pending',
    'Processing',
    'Delivered',
    'Cancelled',
  ];

  Future<List<OrderModel>> getAllOrders({required BuildContext context}) async {
    try {
      final collectionReference = FirebaseFirestore.instance.collectionGroup(
        'orders',
      );
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

  Future<bool> changeOrderStatuc({
    required BuildContext context,
    required String customerId,
    required String orderId,
    required String orderStatus,
  }) async {
    try {
      final ordersCollection = FirebaseFirestore.instance
          .collection("customers")
          .doc(customerId)
          .collection("orders");

      final snapshot = await ordersCollection.get();
      final orderDoc = snapshot.docs.firstWhere(
        (doc) => doc.id == orderId,
        orElse: () => throw Exception("Order not found"),
      );

      final orderData = orderDoc.data();
      final List<dynamic> products = orderData['products'] ?? [];
      log(
        "🚀 changeOrderStatus called for order: $orderId, newStatus: $orderStatus",
      );
      log("Products in order: $products");

      if (orderStatus.toLowerCase() == 'processing') {
        for (final prod in products) {
          final String? productId = prod['productId'] as String?;
          final int? orderedQty = prod['quantity'] as int?;

          if (productId == null || orderedQty == null) {
            log("⚠️ Missing productId or quantity: $prod");
            continue;
          }

          final prodRef = FirebaseFirestore.instance
              .collection('products')
              .doc(productId);

          await FirebaseFirestore.instance.runTransaction((txn) async {
            final prodSnap = await txn.get(prodRef);
            if (!prodSnap.exists) {
              throw Exception("Product $productId not found");
            }

            final currentStock = (prodSnap.get('stock') as int?) ?? 0;
            final newStock = currentStock - orderedQty;
            if (newStock < 0) {
              throw Exception("Insufficient stock for $productId");
            }
            txn.update(prodRef, {'stock': newStock});
            log(
              "✅ Deducted $orderedQty from product $productId, newStock = $newStock",
            );
          });
        }
      }

      await orderDoc.reference.update({'orderStatus': orderStatus});
      log("✅ Order $orderId status updated to $orderStatus in Firestore");

      final idx = _allOrders.indexWhere((e) => e.orderId == orderId);
      if (idx != -1) {
        _allOrders[idx].orderStatus = orderStatus;
      }
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) showSnackBar(context: context, e: e);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e.toString());
      }
      log("❌ changeOrderStatus error: $e");
    }
    return false;
  }

  //filter order by status
  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  List<String> get allOrderStatusForFilter => [
    'All',
    'Pending',
    'Processing',
    'Delivered',
    'Cancelled',
  ];

  void filterOrdersByStatus({required String orderStatus}) {
    _selectedStatus = orderStatus;
    if (orderStatus == 'All') {
      _filterOrders = _allOrders;
    } else {
      _filterOrders = _allOrders
          .where(
            (e) => e.orderStatus.toLowerCase() == orderStatus.toLowerCase(),
          )
          .toList();
    }
    notifyListeners();
  }
}
