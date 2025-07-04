import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/componenet/dash_board_items.dart';
import 'package:desi_shopping_seller/screens/admin/helper/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/screens/admin/dash board/componenet/dash_board_support.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<int> dashboardData = [];

  @override
  void initState() {
    super.initState();
    NotificationHelper.setupFCM();
    NotificationHelper.setupFirebaseForegroundNotifications(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final brandProvider = context.read<BrandProvider>();
      final productProvider = context.read<ProductProvider>();
      final rechargeProvider = context.read<RechargeSimProvider>();
      final customer = context.read<UserProvider>();

      await Future.wait([
        brandProvider.fetchIfNeeded(context: context),
        productProvider.fetchIfNeeded(context: context),
        rechargeProvider.getAllProvider(context: context),
        customer.getAllUsers(context: context),
      ]);

      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final productProvider = context.read<ProductProvider>();
    final brandProvider = context.read<BrandProvider>();
    final userProvider = context.read<UserProvider>();
    final orderProvider = context.read<OrderProvider>();
    orderProvider.getAllOrders(context: context);
    final allOrders = orderProvider.allOrders;
    final today = DateTime.now();
    final todayOrders = allOrders.where((e) {
      final date = e.createdAt!.toDate();
      return date.day == today.day &&
          date.month == today.month &&
          date.year == today.year;
    }).toList();

    setState(() {
      dashboardData = [
        todayOrders.length,
        todayOrders.where((e) => e.orderStatus == 'Pending').length,
        todayOrders.where((e) => e.orderStatus == 'Delivered').length,
        todayOrders.where((e) => e.orderStatus == 'Cancelled').length,
        allOrders.length,
        allOrders.where((e) => e.orderStatus == 'Pending').length,
        allOrders.where((e) => e.orderStatus == 'Delivered').length,
        allOrders.where((e) => e.orderStatus == 'Cancelled').length,
        productProvider.allProduct.length,
        brandProvider.allBrands.length,
        userProvider.allUsers.length,
      ];
    });
  }

  void setupFirebaseForegroundNotifications(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final title = message.notification!.title ?? 'Notification';
        final body = message.notification!.body ?? 'You have a new message';

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title\n$body'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: GridView.builder(
            itemCount: dashBoardItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: size.height * 0.02,
              crossAxisSpacing: size.width * 0.04,
              mainAxisExtent: size.height * 0.22,
            ),
            itemBuilder: (context, index) {
              return DashBoardItem(
                title: dashBoardItems[index],
                count: dashboardData.length > index ? dashboardData[index] : 0,

                icon: _getIcon(index),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    const icons = [
      Icons.today,
      Icons.hourglass_bottom,
      Icons.check_circle,
      Icons.cancel,
      Icons.list_alt,
      Icons.pending_actions,
      Icons.delivery_dining,
      Icons.remove_circle,
      Icons.shopping_bag,
      Icons.branding_watermark,
      Icons.people,
    ];
    return icons[index % icons.length];
  }
}
