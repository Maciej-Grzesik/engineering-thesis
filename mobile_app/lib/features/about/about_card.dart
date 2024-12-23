import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/features/about/about_card_arrows.dart';
import 'package:mobile_app/features/about/about_descriptions.dart';

class AboutCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double padding;

  final int currentPage;
  final int pageCount;
  final PageController pageController;

  const AboutCard(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.padding,
      required this.currentPage,
      required this.pageCount,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final colorScheme = Theme.of(context).colorScheme;


    return Padding(
      padding: EdgeInsets.fromLTRB(padding, padding * 8, padding, padding),
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
                      colorScheme.secondary.withOpacity(0.1),
                      colorScheme.tertiary.withOpacity(0.2),
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
                        titles[currentPage],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          // padding: EdgeInsets.only(right: 8.0),
                          thickness: 6.0,
                          radius: const Radius.circular(4.0),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: EdgeInsets.all(padding),
                            child: Text(
                              descriptions[currentPage],
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: colorScheme.onPrimaryContainer,
                      indent: padding,
                      endIndent: padding,
                    ),
                    AboutCardArrows(
                        padding: padding,
                        currentPage: currentPage,
                        pageController: pageController,
                        pageCount: pageCount)
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
