import 'package:desi_shopping_seller/screens/banners/banners_page.dart';
import 'package:desi_shopping_seller/screens/brands%20page/brand_page.dart';
import 'package:desi_shopping_seller/screens/customers%20screen/all_customers_list.dart';
import 'package:desi_shopping_seller/screens/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/screens/orders/orders_page.dart';
import 'package:desi_shopping_seller/screens/products/all_products_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//drawer
final drawerGradient = [Colors.lightBlue, Colors.lightBlueAccent];

List<String> drawerItems = [
  "DashBoard",
  "Brands",
  "Banners",
  "Products",
  "Orders",
  "Customers",
];

List<IconData> drawerIcons = [
  Icons.dashboard,
  Icons.branding_watermark_sharp,
  Icons.image,
  Icons.production_quantity_limits,
  Icons.shopping_bag,
  Icons.person,
];

List<Widget> pages = [
  const AdvanceDrawerPage(body: DashBoardPage(), title: 'DashBoard'),
  const AdvanceDrawerPage(body: BrandPage(), title: 'Brands'),
  const AdvanceDrawerPage(body: BannersPage(), title: 'Banners'),
  const AdvanceDrawerPage(body: AllProductsPage(), title: 'Products'),
  const AdvanceDrawerPage(body: OrdersPage(), title: 'Orders'),
  const AdvanceDrawerPage(body: AllCustomersList(), title: 'Customers'),
];
Widget draweFunctions() {
  return ListView.builder(
    itemCount: drawerItems.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return ListTile(
        onTap: () => Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: const Duration(milliseconds: 400),
            child: pages[index],
          ),
        ),
        leading: Icon(drawerIcons[index]),
        title: Text(drawerItems[index]),
      );
    },
  );
}
