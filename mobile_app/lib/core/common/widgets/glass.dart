import 'dart:ui';

import 'package:flutter/material.dart';

class Glass extends StatefulWidget {
  const Glass({super.key, required this.child});

  final Widget child;

  @override
  State<Glass> createState() => _GlassState();
}

class _GlassState extends State<Glass> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              margin: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.1,
                vertical: constraints.maxHeight * 0.1,
              ),
              child: widget.child,
            ),
          ),
        ),
      );
    });
  }
}
