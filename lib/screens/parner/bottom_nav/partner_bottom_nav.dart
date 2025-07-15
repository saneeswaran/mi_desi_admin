import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/screens/parner/dashboard/partner_dashboard.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile%20page/partner_profile_page.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile/partner_products_page.dart';
import 'package:desi_shopping_seller/screens/parner/recharge%20request%20screen/partner_recharge_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerBottomNav extends StatefulWidget {
  const PartnerBottomNav({super.key});

  @override
  State<PartnerBottomNav> createState() => _PartnerBottomNavState();
}

class _PartnerBottomNavState extends State<PartnerBottomNav> {
  int _currentIndex = 0;
  List<String> titles = ['Home', 'Products', "Recharge", 'Profile'];
  List<Widget> pages = [
    const PartnerDashboard(),
    const PartnerProductsPage(),
    const PartnerRechargeRequestScreen(),
    const PartnerProfilePage(),
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.shopping_bag,
    Icons.receipt_sharp,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    context.read<AuthProviders>().getCurrentUserDetails(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProviders>();
    return FutureBuilder(
      future: authProvider.getCurrentUserDetails(context: context),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (asyncSnapshot.data!.activeStatus == "inactive") {
          return const Scaffold(body: Center(child: Text("Account Inactive")));
        }
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (int index) => setState(() => _currentIndex = index),
            currentIndex: _currentIndex,
            items: List.generate(
              titles.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(icons[index]),
                label: titles[index],
              ),
            ),
          ),
          body: pages[_currentIndex],
        );
      },
    );
  }
}
