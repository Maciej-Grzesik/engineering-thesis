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
          print("onhorizontaldragupdate");
          if (details.delta.dx > 100) {
            print("onOpenMenu0");
            onOpenMenu();
          } else if (details.delta.dx < 0) {
            print("onCloseMenu");
            onCloseMenu();
          }
        }
      },
      onHorizontalDragEnd: (details) {
        print("onhorizontaldragend");
        print('primaryVelocity: ${details.primaryVelocity}');
        if (details.primaryVelocity! < -200) {
          print("onCloseMenu");
          onCloseMenu();
        } else if (details.primaryVelocity! > 200) {
          print("onOpenMenu");
          onOpenMenu();
        }
      },
      child: child,
    );
  }
}
