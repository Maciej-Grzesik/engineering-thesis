import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = 16.0;
    final pageCount = 4;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildCard(
                    screenWidth, screenHeight, padding, index, pageCount);
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: padding * 8),
          child: SizedBox(
            height: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageCount,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? context.colorScheme.secondaryContainer
                        : context.colorScheme.onSecondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(double screenWidth, double screenHeight, double padding,
      int index, int pageCount) {
    final titles = ["App 1 Title", "App 2 Title", "App 3 Title", "App 4 Title"];

    final descriptions = [
      "This is a description of the first app. It provides amazing features. This is a long description to demonstrate scrolling. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      "This is a description of the second app. It's built with Flutter. It's an incredible tool for building cross-platform apps. Vivamus hendrerit arcu sed arcu. Curabitur gravida arcu ac tortor dignissim.",
      "This is a description of the third app. It has a clean and modern UI. Aenean vel elit scelerisque mauris pellentesque. Ut enim blandit volutpat maecenas volutpat. Mauris commodo quis imperdiet massa tincidunt nunc.",
      "This is a description of the fourth app. It's optimized for performance. Pharetra magna ac placerat vestibulum lectus. Id venenatis a condimentum vitae sapien pellentesque. Volutpat diam ut venenatis tellus in metus. This is a description of the fourth app. It's optimized for performance. Pharetra magna ac placerat vestibulum lectus. Id venenatis a condimentum vitae sapien pellentesque. Volutpat diam ut venenatis tellus in metus. This is a description of the fourth app. It's optimized for performance. Pharetra magna ac placerat vestibulum lectus. Id venenatis a condimentum vitae sapien pellentesque. Volutpat diam ut venenatis tellus in metus. This is a description of the fourth app. It's optimized for performance. Pharetra magna ac placerat vestibulum lectus. Id venenatis a condimentum vitae sapien pellentesque. Volutpat diam ut venenatis tellus in metus."
    ];

    return Card(
      margin: EdgeInsets.fromLTRB(padding, padding * 8, padding, padding),
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: screenWidth - padding * 2,
                height: screenHeight - padding * 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.secondary.withOpacity(0.1),
                      context.colorScheme.tertiary.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding, top: padding, right: padding),
                      child: Text(
                        titles[index],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
  child: Scrollbar( 
    thumbVisibility: true,
    child: SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Text(
        descriptions[index],
        style: TextStyle(
          fontSize: 16,
          color: context.colorScheme.onSurface,
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  ),
),

                    
                    Divider(
                      thickness: 1,
                      color: context.colorScheme.onPrimaryContainer,
                      indent: padding,
                      endIndent: padding,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Row(
                        mainAxisAlignment: index > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                        children: [
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.arrow_back_sharp,
                                  size: 48,
                                  color:
                                      context.colorScheme.onPrimaryContainer),
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutQuad,
                                );
                              },
                            ),
                          if (index < pageCount - 1)
                            IconButton(
                              icon: Icon(Icons.arrow_forward_sharp,
                                  size: 48,
                                  color:
                                      context.colorScheme.onPrimaryContainer),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
