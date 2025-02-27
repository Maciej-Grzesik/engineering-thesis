import 'dart:ui';
import 'package:flutter/material.dart';

class StyledExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const StyledExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.1),
                  colorScheme.tertiary.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Theme(
              data: ThemeData(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                childrenPadding: const EdgeInsets.all(16),
                children: [
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
