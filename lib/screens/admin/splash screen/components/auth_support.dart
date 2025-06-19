import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class SplashScreenPageView extends StatefulWidget {
  const SplashScreenPageView({super.key});

  @override
  State<SplashScreenPageView> createState() => _SplashScreenPageViewState();
}

class _SplashScreenPageViewState extends State<SplashScreenPageView> {
  int _currentIndex = 0;
  late final PageController _pageController;

  List<String> imageUrl = [AppImages.easyShop, AppImages.herbalImage];
  List<String> description = [
    "Explore Premier Health & Wellness \nSolutions Here!",
    "Discover Unmatched Excellence with \n Our Mobile App!",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        int next = _pageController.page!.round();
        if (_currentIndex != next) {
          setState(() {
            _currentIndex = next;
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.03),
          height: size.height * 0.45,
          width: size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrl.length,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                width: size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.33,
                      width: size.width,
                      child: Image.asset(imageUrl[index], fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        DotsIndicator(
          dotsCount: imageUrl.length,
          position: _currentIndex.toDouble(),
          decorator: const DotsDecorator(
            activeColor: Colors.pink,
            color: Color.fromARGB(255, 215, 213, 213),
          ),
        ),
      ],
    );
  }
}
