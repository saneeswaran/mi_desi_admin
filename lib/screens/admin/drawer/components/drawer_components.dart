import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/screens/admin/all%20rechagres/all_recharges_page.dart';
import 'package:desi_shopping_seller/screens/admin/banners/banners_page.dart';
import 'package:desi_shopping_seller/screens/admin/brands%20page/brand_page.dart';
import 'package:desi_shopping_seller/screens/admin/customers%20screen/all_customers_list.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/screens/admin/orders/orders_page.dart';
import 'package:desi_shopping_seller/screens/admin/partner/list_of_partners.dart';
import 'package:desi_shopping_seller/screens/admin/products/all_products_page.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20provider/recharge_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//drawer
final drawerGradient = [Colors.lightBlue, Colors.lightBlueAccent];

List<String> drawerItems = [
  "DashBoard",
  "Brands",
  "Banners",
  "Products",
  "Orders",
  'Partners',
  "Recharge Provider",
  "Recharges",
  "Customers",
];

List<IconData> drawerIcons = [
  Icons.dashboard,
  Icons.branding_watermark_sharp,
  Icons.image,
  Icons.production_quantity_limits,
  Icons.shopping_bag,
  Icons.person_2,
  Icons.mobile_friendly,
  Icons.mobile_friendly,
  Icons.person,
];

List<Widget> pages = [
  const AdvanceDrawerPage(body: DashBoardPage(), title: 'DashBoard'),
  const AdvanceDrawerPage(body: BrandPage(), title: 'Brands'),
  const AdvanceDrawerPage(body: BannersPage(), title: 'Banners'),
  const AdvanceDrawerPage(body: AllProductsPage(), title: 'Products'),
  const AdvanceDrawerPage(body: OrdersPage(), title: 'Orders'),
  const AdvanceDrawerPage(body: ListOfPartners(), title: 'Partners'),
  const AdvanceDrawerPage(
    body: RechargeProviderPage(),
    title: 'Recharge Provider',
  ),
  const AdvanceDrawerPage(body: AllRechargesPage(), title: 'Recharges'),
  const AdvanceDrawerPage(body: AllCustomersList(), title: 'Customers'),
];
Widget draweFunctions({required BuildContext context}) {
  return Column(
    children: [
      ListView.builder(
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
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Logout", style: TextStyle(color: Colors.black)),
        onTap: () {
          Provider.of<AuthProviders>(context, listen: false).logout();
        },
      ),
    ],
  );
}
