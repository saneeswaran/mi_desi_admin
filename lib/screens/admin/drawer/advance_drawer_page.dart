// ignore_for_file: deprecated_member_use
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/components/drawer_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AdvanceDrawerPage extends StatelessWidget {
  final String title;
  final Widget body;
  const AdvanceDrawerPage({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final advancedDrawerController = AdvancedDrawerController();
    void handleMenuButtonPressed() {
      advancedDrawerController.showDrawer();
    }

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.backgroundImages)),
        ),
      ),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.black,
          iconColor: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: size.height * 0.20,
                  width: size.width * 0.70,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(Icons.person, size: 32),
                ),
                draweFunctions(context: context),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            onPressed: handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: advancedDrawerController,
              builder: (context, value, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Semantics(
                    label: 'Menu',
                    onTapHint: 'expand drawer',
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        body: body,
      ),
    );
  }
}
