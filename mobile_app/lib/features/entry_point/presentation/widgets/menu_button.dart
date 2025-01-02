import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.isMenuOpen,
    required this.press,
  });

  final bool isMenuOpen;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: const EdgeInsets.only(left: 16),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline,
            ),
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow,
                offset: const Offset(1, 2),
                blurRadius: 3,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isMenuOpen ? Icons.close_outlined : Icons.menu,
              key: ValueKey<bool>(isMenuOpen),
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
