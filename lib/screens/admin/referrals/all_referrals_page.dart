import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/customer_model.dart';
import 'package:desi_shopping_seller/providers/referral_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllReferralsPage extends StatefulWidget {
  const AllReferralsPage({super.key});

  @override
  State<AllReferralsPage> createState() => _AllReferralsPageState();
}

class _AllReferralsPageState extends State<AllReferralsPage> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      context.read<ReferralProvider>().getAllReferrals(context: context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final referralProvider = context.read<ReferralProvider>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: userProvider.filterUsers.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            final user = userProvider.filterUsers[index];
            return ListTile(
              title: Text(
                user.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                // Filter users who were referred by the current user
                List<CustomerModel> referredCustomers = referralProvider
                    .allReferral
                    .where((referral) => referral.referredBy == user.uid)
                    .map(
                      (referral) => userProvider.allUsers.firstWhere(
                        (customer) => customer.uid == referral.referredTo,
                        orElse: () =>
                            CustomerModel(name: '', email: '', imageUrl: ''),
                      ),
                    )
                    .toList();

                normalDialog(
                  context: context,
                  title: "Referrals",
                  size: size,
                  height: size.height * 0.8,
                  width: size.width * 1,
                  widget: referredCustomers.isEmpty
                      ? const Center(
                          child: Text(
                            "No Referrals",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: referredCustomers.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final customer = referredCustomers[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              height: size.height * 0.15,
                              width: size.width * 1,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pink,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    customer.email,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    customer.usedReferralCode.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
