import 'package:desi_shopping_seller/screens/admin/drawer/model/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DrawerItemTile extends StatelessWidget {
  final DrawerItem item;

  const DrawerItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: const Duration(milliseconds: 400),
            child: item.page,
          ),
        );
      },
      leading: Icon(item.icon),
      title: Text(item.title),
    );
  }
}
