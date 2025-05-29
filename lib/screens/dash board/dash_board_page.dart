import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/dash%20board/componenet/dash_board_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Consumer<ProductProvider>(
          builder: (context, value, child) {
            return GridView.builder(
              itemCount: dashBoardItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: size.height * 0.02,
                mainAxisExtent: size.height * 0.24,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(28, 28, 28, 1),
                      border: Border(
                        left: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                        right: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                        top: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                      ),
                    ),
                    child: Column(
                      spacing: size.height * 0.04,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Text(
                          dashBoardItems[index],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          index.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
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
