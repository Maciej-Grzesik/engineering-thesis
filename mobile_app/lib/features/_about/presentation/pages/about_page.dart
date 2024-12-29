import 'package:flutter/material.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card.dart';
import 'package:mobile_app/features/_about/presentation/widgets/bottom_scroll_icons.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 3;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const padding = 16.0;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return AboutCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  padding: padding,
                  currentPage: _currentPage,
                  pageCount: pageCount,
                  pageController: _pageController,
                );
              },
            ),
          ),
        ),
        BottomScrollIcons(
          pageCount: pageCount,
          currentPage: _currentPage,
        ),
      ],
    );
  }
}
