import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final bool isCameraPage;
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.isCameraPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: FloatingActionButton(
        key: ValueKey<bool>(isCameraPage),
        shape: const CircleBorder(),
        backgroundColor: colorScheme.primary,
        onPressed: onPressed,
        child: Icon(
          isCameraPage ? Icons.clear : Icons.camera_alt,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}