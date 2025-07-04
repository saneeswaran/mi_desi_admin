import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/screens/admin/helper/notification_helper.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
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
    Future.wait([
      context.read<ReachargesProvider>().getAllRechageRechargeRequest(
        context: context,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rechargeProvider = context.watch<ReachargesProvider>();
    final rechargeRequests = rechargeProvider.filterRechargeRequest;

    return Scaffold(
      body: rechargeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : rechargeRequests.isEmpty
          ? const Center(child: Text("No recharge requests found."))
          : ListView.builder(
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
                            child: const Text(
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
                              switch (rechargeStatus) {
                                case "Success":
                                  NotificationHelper.sendNotification(
                                    title: "Recharge Success",
                                    message:
                                        "Your ${recharge.price} has been recharged successfully",
                                    screen: "/recharge",
                                    userId: recharge.customerId.toString(),
                                  );
                                  break;
                                case "Failed":
                                  NotificationHelper.sendNotification(
                                    title: "Recharge Failed",
                                    message:
                                        "Your ${recharge.price} has been failed",
                                    screen: "/recharge",
                                    userId: recharge.customerId.toString(),
                                  );
                                  break;
                                case "Pending":
                                  NotificationHelper.sendNotification(
                                    title: "Recharge Pending",
                                    message:
                                        "Your ${recharge.price} has been pending",
                                    screen: "/recharge",
                                    userId: recharge.customerId.toString(),
                                  );
                                  break;
                                default:
                                  break;
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
