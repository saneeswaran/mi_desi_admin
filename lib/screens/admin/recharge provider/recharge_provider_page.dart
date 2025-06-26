import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20provider/components/create_recharge_provider.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20provider/components/view_recharge_plan.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RechargeProviderPage extends StatelessWidget {
  const RechargeProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        shape: const CircleBorder(),
        backgroundColor: Colors.pink,
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const CreateRechargeProvider(),
        ),
        tooltip: "Add Recharge Provider",
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RechargeSimProvider>(
          builder: (context, provider, child) {
            return GridView.builder(
              itemCount: provider.allProvider.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final rechargeProvider = provider.allProvider[index];
                return GestureDetector(
                  onTap: () => moveToNextPageWithFadeAnimations(
                    context: context,
                    route: ViewRechargePlan(recharge: rechargeProvider),
                  ),
                  child: GridTile(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            rechargeProvider.image,
                          ),
                          radius: 35,
                        ),
                        Text(
                          rechargeProvider.providerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
