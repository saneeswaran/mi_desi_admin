import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text("Logout", style: TextStyle(color: Colors.black)),
      onTap: () {
        Provider.of<AuthProviders>(context, listen: false).logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      },
    );
  }
}
