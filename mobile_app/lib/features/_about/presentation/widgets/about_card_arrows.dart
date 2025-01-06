import 'package:flutter/material.dart';

class AboutCardArrows extends StatelessWidget {
  const AboutCardArrows({
    super.key,
    required this.padding,
    required this.currentPage,
    required this.pageController,
    required this.pageCount,
  });

  final double padding;
  final int currentPage;
  final PageController pageController;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: currentPage > 0
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (currentPage > 0)
            IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuad,
                );
              },
            ),
          if (currentPage < pageCount - 1)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_sharp,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
        ],
      ),
    );
  }
}
