import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllRechargesPage extends StatefulWidget {
  const AllRechargesPage({super.key});

  @override
  State<AllRechargesPage> createState() => _AllRechargesPageState();
}

class _AllRechargesPageState extends State<AllRechargesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReachargesProvider>().getAllRechargeModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Consumer<ReachargesProvider>(
          builder: (context, provider, child) {
            return GridView.builder(
              itemCount: provider.allRecharge.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                final plans = provider.allRecharge[index];
                return GridTile(
                  child: Column(
                    children: [
                      Text(plans.price.toString()),
                      Text(plans.dataInfo),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
