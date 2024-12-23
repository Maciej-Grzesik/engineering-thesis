import 'package:flutter/material.dart';
import 'package:mobile_app/features/about/about_card.dart';
import 'package:mobile_app/features/about/bottom_scroll_icons.dart';

class AboutPageWidget extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;

  const AboutPageWidget(
      {super.key,
      required this.pageController,
      required this.currentPage,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const padding = 16.0;
    const pageCount = 4;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: PageView.builder(
              controller: pageController,
              itemCount: pageCount,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                return AboutCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  padding: padding,
                  currentPage: currentPage,
                  pageCount: pageCount,
                  pageController: pageController,
                );
              },
            ),
          ),
        ),
        BottomScrollIcons(
          pageCount: pageCount,
          currentPage: currentPage,
        ),
      ],
    );
  }
}
