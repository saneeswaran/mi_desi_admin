import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/customer_model.dart';
import 'package:desi_shopping_seller/model/order_model.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/screens/admin/helper/notification_helper.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowOrderDetailsPage extends StatefulWidget {
  final OrderModel order;
  final CustomerModel customer;
  const ShowOrderDetailsPage({
    super.key,
    required this.order,
    required this.customer,
  });

  @override
  State<ShowOrderDetailsPage> createState() => _ShowOrderDetailsPageState();
}

class _ShowOrderDetailsPageState extends State<ShowOrderDetailsPage> {
  String status = "Pending";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Order Details"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Customer Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              widget.customer.imageUrl != null &&
                                  widget.customer.imageUrl!.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  widget.customer.imageUrl!,
                                )
                              : null,
                          backgroundColor: Colors.grey[300],
                          child:
                              widget.customer.imageUrl == null ||
                                  widget.customer.imageUrl!.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.customer.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.customer.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      "Order ID",
                      widget.order.orderId.toString(),
                    ),

                    _buildDetailRow("Status", widget.order.orderStatus),
                    _buildDetailRow(
                      "Phone Number",
                      widget.order.phoneNumber.toString(),
                    ),
                    _buildDetailRow("Address", widget.order.address),
                    _buildDetailRow(
                      "Total Amount",
                      "$currency ${widget.order.totalAmount}",
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    const Text(
                      "Products Ordered",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ListView.builder(
                      itemCount: widget.order.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = widget.order.products[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product["imageUrl"] ?? '',
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["title"] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${product["quantity"]} x $currency${product["price"]}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    _changeOrderStatus(),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: size.height * 0.07,
                      width: size.width,
                      child: CustomElevatedButton(
                        child: const Text(
                          "Update Status",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          final provider = Provider.of<OrderProvider>(
                            context,
                            listen: false,
                          );
                          setState(() => isLoading = true);
                          final bool isSuccess = await provider
                              .changeOrderStatuc(
                                context: context,
                                customerId: widget.order.userId,
                                orderId: widget.order.orderId,
                                orderStatus: status,
                              );
                          if (isSuccess && context.mounted) {
                            setState(() => isLoading = false);
                            Navigator.pop(context);
                            showSnackBar(context: context, e: "Status Updated");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black12,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pink),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeOrderStatus() {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        final items = provider.allOrderStatus
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList();
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: "Change Status",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pink),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pink),
            ),
          ),
          items: items,
          onChanged: (value) {
            setState(() {
              status = value.toString();
            });

            String message = "Your order is $status";
            NotificationHelper.sendNotification(
              title: "Order $status".toUpperCase(),
              message: message,
              screen: "/order",
              userId: widget.order.userId,
            );
          },
        );
      },
    );
  }
}
