import 'package:flutter/material.dart';
import 'package:mobile_app/utils/theme_provider.dart';

class BottomScrollIcons extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const BottomScrollIcons(
      {super.key, required this.currentPage, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    const padding = 16.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: padding * 8),
      child: SizedBox(
        height: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? context.colorScheme.secondaryContainer
                    : context.colorScheme.onSecondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}