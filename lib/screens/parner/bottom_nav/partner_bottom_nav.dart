import 'package:desi_shopping_seller/enum/app_enum.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/screens/parner/dashboard/partner_dashboard.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile/partner_products_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerBottomNav extends StatefulWidget {
  const PartnerBottomNav({super.key});

  @override
  State<PartnerBottomNav> createState() => _PartnerBottomNavState();
}

class _PartnerBottomNavState extends State<PartnerBottomNav> {
  int _currentIndex = 0;
  List<String> titles = ['Home', 'Products', 'Profile'];
  List<Widget> pages = [
    const PartnerDashboard(),
    const PartnerProductsPage(),
    const PartnerProductsPage(),
  ];
  List<IconData> icons = [Icons.home, Icons.shopping_bag, Icons.person];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final partnerProductsPage = Provider.of<PartnerProvider>(context);
    final status = partnerProductsPage.partner!.activeStatus;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: List.generate(
          titles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: titles[index],
          ),
        ),
      ),
      body: status == PartnerStatus.inactive
          ? Center(
              child: SizedBox(
                height: size.height * 1,
                width: size.width * 1,
                child: const Text(
                  "You don't have access until you get verified",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : pages[_currentIndex],
    );
  }
}
