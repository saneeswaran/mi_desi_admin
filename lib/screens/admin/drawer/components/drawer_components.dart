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
import 'package:desi_shopping_seller/screens/admin/real%20brands/real_brand_page.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20provider/recharge_provider_page.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20request/recharge_request_page.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/auth_page.dart';
import 'package:desi_shopping_seller/screens/admin/youtube%20video/youtube_videos_list.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//drawer
final drawerGradient = [Colors.lightBlue, Colors.lightBlueAccent];

List<String> drawerItems = [
  "DashBoard",
  "Category Brands",
  "Original Brands",
  "Banners",
  "Youtube Videos",
  "Products",
  "Orders",
  'Partners',
  "Recharge Provider",
  "Recharges",
  "Recharge Request",
  "Customers",
];

List<IconData> drawerIcons = [
  Icons.dashboard,
  Icons.branding_watermark_sharp,
  Icons.branding_watermark_outlined,
  Icons.image,
  Icons.video_collection,
  Icons.production_quantity_limits,
  Icons.shopping_bag,
  Icons.person_2,
  Icons.mobile_friendly,
  Icons.mobile_friendly,
  Icons.mobile_off,
  Icons.person,
];

List<Widget> pages = [
  const AdvanceDrawerPage(body: DashBoardPage(), title: 'DashBoard'),
  const AdvanceDrawerPage(body: BrandPage(), title: 'Category Brands'),
  const AdvanceDrawerPage(body: RealBrandPage(), title: "Original Brands"),
  const AdvanceDrawerPage(body: BannersPage(), title: 'Banners'),
  const AdvanceDrawerPage(body: YoutubeVideosList(), title: "Youtube Videos"),
  const AdvanceDrawerPage(body: AllProductsPage(), title: 'Products'),
  const AdvanceDrawerPage(body: OrdersPage(), title: 'Orders'),
  const AdvanceDrawerPage(body: ListOfPartners(), title: 'Partners'),
  const AdvanceDrawerPage(
    body: RechargeProviderPage(),
    title: 'Recharge Provider',
  ),
  const AdvanceDrawerPage(body: AllRechargesPage(), title: 'Recharges'),
  const AdvanceDrawerPage(
    body: RechargeRequestPage(),
    title: 'Recharge Request',
  ),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        },
      ),
    ],
  );
}
