import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 35.0;
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    path.addRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        const Radius.circular(12),
      ),
    );
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
