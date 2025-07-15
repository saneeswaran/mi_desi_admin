import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerDashboard extends StatefulWidget {
  const PartnerDashboard({super.key});

  @override
  State<PartnerDashboard> createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProviders>().getCurrentUserDetails(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
