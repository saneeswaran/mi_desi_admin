import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void dashBoardInits(BuildContext context) {
  context.read<ProductProvider>().getSellerProducts(context: context);
  context.read<OrderProvider>().getAllOrders(context: context);
  context.read<UserProvider>().getAllUsers(context: context);
}
