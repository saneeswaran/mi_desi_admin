import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/recharge_model.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/screens/admin/all%20rechagres/components/add_recharge_page.dart';
import 'package:desi_shopping_seller/screens/admin/all%20rechagres/components/edit_recharge_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.pink,
        shape: const CircleBorder(),
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddRechargePage(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Consumer<ReachargesProvider>(
            builder: (context, provider, child) {
              final allPlans = provider.allRecharge;

              final groupedPlans = <String, List<RechargeModel>>{};
              for (var plan in allPlans) {
                final providerName = plan.rechargeProvider;
                if (!groupedPlans.containsKey(providerName)) {
                  groupedPlans[providerName] = [];
                }
                groupedPlans[providerName]!.add(plan);
              }

              final providerNames = groupedPlans.keys.toList()..sort();

              return ListView.separated(
                itemCount: providerNames.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final providerName = providerNames[index];
                  final plans = groupedPlans[providerName]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: plans.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, planIndex) {
                          final plan = plans[planIndex];
                          return ListTile(
                            onTap: () => moveToNextPageWithFadeAnimations(
                              context: context,
                              route: EditRechargePage(rechargeModel: plan),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: Colors.grey.shade100,
                            title: Text("₹${plan.price.toStringAsFixed(0)}"),
                            subtitle: Text(
                              "${plan.dataInfo} • ${plan.validity}",
                            ),
                            trailing: Text(
                              plan.status ?? '',
                              style: TextStyle(
                                color: plan.status == "Active"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
