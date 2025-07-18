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
import 'package:desi_shopping_seller/screens/admin/referrals/all_referrals_page.dart';
import 'package:desi_shopping_seller/screens/admin/youtube%20video/youtube_videos_list.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget page;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}

const List<DrawerItem> drawerItemsList = [
  DrawerItem(
    title: "DashBoard",
    icon: Icons.dashboard,
    page: AdvanceDrawerPage(body: DashBoardPage(), title: 'DashBoard'),
  ),
  DrawerItem(
    title: "Category Brands",
    icon: Icons.branding_watermark_sharp,
    page: AdvanceDrawerPage(body: BrandPage(), title: 'Category Brands'),
  ),
  DrawerItem(
    title: "Original Brands",
    icon: Icons.branding_watermark_outlined,
    page: AdvanceDrawerPage(body: RealBrandPage(), title: "Original Brands"),
  ),
  DrawerItem(
    title: "Banners",
    icon: Icons.image,
    page: AdvanceDrawerPage(body: BannersPage(), title: 'Banners'),
  ),
  DrawerItem(
    title: "Youtube Videos",
    icon: Icons.video_collection,
    page: AdvanceDrawerPage(body: YoutubeVideosList(), title: "Youtube Videos"),
  ),
  DrawerItem(
    title: "Products",
    icon: Icons.production_quantity_limits,
    page: AdvanceDrawerPage(body: AllProductsPage(), title: 'Products'),
  ),
  DrawerItem(
    title: "Orders",
    icon: Icons.shopping_bag,
    page: AdvanceDrawerPage(body: OrdersPage(), title: 'Orders'),
  ),
  DrawerItem(
    title: "Partners",
    icon: Icons.person_2,
    page: AdvanceDrawerPage(body: ListOfPartners(), title: 'Partners'),
  ),
  DrawerItem(
    title: "Recharge Provider",
    icon: Icons.mobile_friendly,
    page: AdvanceDrawerPage(
      body: RechargeProviderPage(),
      title: 'Recharge Provider',
    ),
  ),
  DrawerItem(
    title: "Recharges",
    icon: Icons.mobile_friendly,
    page: AdvanceDrawerPage(body: AllRechargesPage(), title: 'Recharges'),
  ),
  DrawerItem(
    title: "Recharge Request",
    icon: Icons.mobile_off,
    page: AdvanceDrawerPage(
      body: RechargeRequestPage(),
      title: 'Recharge Request',
    ),
  ),
  DrawerItem(
    title: "Customers",
    icon: Icons.person,
    page: AdvanceDrawerPage(body: AllCustomersList(), title: 'Customers'),
  ),
  DrawerItem(
    title: "Referrals",
    icon: Icons.person_add,
    page: AdvanceDrawerPage(body: AllReferralsPage(), title: "Referrals"),
  ),
];
