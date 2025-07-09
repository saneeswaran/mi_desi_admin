import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/componenet/dash_board_items.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/componenet/dash_board_support.dart';
import 'package:desi_shopping_seller/screens/admin/helper/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<int>? dashboardData;

  @override
  void initState() {
    super.initState();
    NotificationHelper.setupFCM();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${message.notification!.title}\n${message.notification!.body}',
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  Future<void> _initializeData() async {
    final brandProvider = context.read<BrandProvider>();
    final productProvider = context.read<ProductProvider>();
    final rechargeProvider = context.read<RechargeSimProvider>();
    final userProvider = context.read<UserProvider>();
    final orderProvider = context.read<OrderProvider>();

    await Future.wait([
      brandProvider.fetchIfNeeded(context: context),
      productProvider.fetchIfNeeded(context: context),
      rechargeProvider.getAllProvider(context: context),
      userProvider.getAllUsers(context: context),
      orderProvider.getAllOrders(context: context),
    ]);

    _loadDashboardData();
  }

  void _loadDashboardData() {
    final orderProvider = context.read<OrderProvider>();
    final allOrders = orderProvider.allOrders;
    final today = DateTime.now();

    final todayOrders = allOrders.where((order) {
      final ts = order.createdAt.toDate();
      return ts.year == today.year &&
          ts.month == today.month &&
          ts.day == today.day;
    }).toList();

    setState(() {
      dashboardData = [
        todayOrders.length,
        todayOrders
            .where((o) => o.orderStatus.toLowerCase() == 'pending')
            .length,
        todayOrders
            .where((o) => o.orderStatus.toLowerCase() == 'delivered')
            .length,
        todayOrders
            .where((o) => o.orderStatus.toLowerCase() == 'cancelled')
            .length,
        allOrders.length,
        allOrders.where((o) => o.orderStatus.toLowerCase() == 'pending').length,
        allOrders
            .where((o) => o.orderStatus.toLowerCase() == 'delivered')
            .length,
        allOrders
            .where((o) => o.orderStatus.toLowerCase() == 'cancelled')
            .length,
        context.read<ProductProvider>().allProduct.length,
        context.read<BrandProvider>().allBrands.length,
        context.read<UserProvider>().allUsers.length,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: dashboardData == null
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
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
                      count: dashboardData!.length > index
                          ? dashboardData![index]
                          : 0,
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
