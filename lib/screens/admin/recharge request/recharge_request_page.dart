import 'dart:developer';

import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/screens/admin/helper/notification_helper.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RechargeRequestPage extends StatefulWidget {
  const RechargeRequestPage({super.key});

  @override
  State<RechargeRequestPage> createState() => _RechargeRequestPageState();
}

class _RechargeRequestPageState extends State<RechargeRequestPage> {
  String? rechargeStatus;
  @override
  void initState() {
    super.initState();
    final provider = context.read<ReachargesProvider>();
    provider.getAllRechageRechargeRequest(context: context);
    context.read<UserProvider>().getAllUsers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rechargeProvider = context.watch<ReachargesProvider>();
    final rechargeRequests = rechargeProvider.filterRechargeRequest;
    final userProvider = context.read<UserProvider>().filterUsers;

    final isLoading = rechargeProvider.isUpdateLoading;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 1,
            child: ListView.builder(
              itemCount: rechargeProvider.allFilterMethods.length,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final isSelected = rechargeProvider.currentIndex == index;
                return GestureDetector(
                  onTap: () {
                    rechargeProvider.changeIndex(index);
                    rechargeProvider.filterRechargeByStatus(
                      status: rechargeProvider.allFilterMethods[index],
                    );
                    log(rechargeProvider.allFilterMethods[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    height: size.height * 0.2,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? Colors.pink : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        rechargeProvider.allFilterMethods[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rechargeRequests.length,
              itemBuilder: (context, index) {
                final recharge = rechargeRequests[index];
                return GestureDetector(
                  onTap: () {
                    normalDialog(
                      context: context,
                      title: "Updated Recharge Status",
                      size: size,
                      height: size.height * 0.2,
                      width: size.width * 0.8,
                      widget: Column(
                        spacing: size.height * 0.02,
                        children: [
                          _statusDropDown(),
                          const SizedBox(height: 10),
                          CustomElevatedButton(
                            child: isLoading
                                ? const Loader()
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            onPressed: () async {
                              final bool isSuccess = await rechargeProvider
                                  .updateRechargeStatus(
                                    context: context,
                                    customerId: recharge.customerId.toString(),
                                    rechargeId: recharge.id.toString(),
                                    status: rechargeStatus!,
                                  );
                              if (context.mounted) {
                                NotificationHelper.sendNotification(
                                  title: 'Recharge $rechargeStatus',
                                  message:
                                      'Your ₹${recharge.price.toStringAsFixed(2)} is $rechargeStatus.',
                                  screen: '/recharge',
                                  userId: recharge.customerId!,
                                );
                                Navigator.pop(context);
                              }

                              if (isSuccess && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },

                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Provider", recharge.rechargeProvider),
                          _infoRow("Data Info", recharge.dataInfo),
                          _infoRow("Validity", recharge.validity),
                          _infoRow(
                            "Price",
                            "₹${recharge.price.toStringAsFixed(2)}",
                          ),
                          _infoRow(
                            "Status",
                            recharge.status ?? "Pending",
                            color: _getStatusColor(recharge.status),
                          ),
                          _infoRow(
                            "Requested At",
                            recharge.createdAt != null
                                ? DateFormat(
                                    'dd MMM yyyy, hh:mm a',
                                  ).format(recharge.createdAt!.toDate())
                                : "N/A",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "success":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "pending":
      default:
        return Colors.orange;
    }
  }

  Widget _statusDropDown() {
    final items = [
      "Pending",
      "Success",
      "Failed",
    ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: "Change Status",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      items: items,
      value: rechargeStatus,
      onChanged: (value) {
        setState(() {
          rechargeStatus = value;
        });
      },
    );
  }
}
