import 'package:flutter/material.dart';

class OpenMenuGestureDetector extends StatelessWidget {
  final Widget child;
  final Function onOpenMenu;
  final Function onCloseMenu;

  const OpenMenuGestureDetector({
    super.key,
    required this.child,
    required this.onOpenMenu,
    required this.onCloseMenu,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.localPosition.dx < 100) {
          if (details.delta.dx > 100) {
            onOpenMenu();
          } else if (details.delta.dx < 0) {
            onCloseMenu();
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -200) {
          onCloseMenu();
        } else if (details.primaryVelocity! > 200) {
          onOpenMenu();
        }
      },
      child: child,
    );
  }
}
