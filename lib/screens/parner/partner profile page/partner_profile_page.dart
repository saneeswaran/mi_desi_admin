import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerProfilePage extends StatelessWidget {
  const PartnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<AuthProviders>(context, listen: false).logout();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
