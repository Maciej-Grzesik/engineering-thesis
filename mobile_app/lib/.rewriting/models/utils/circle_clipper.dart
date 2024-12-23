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

class BorderPainter extends CustomPainter {
  final Color color;

  BorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const radius = 35.0;
    final center = Offset(size.width / 2, size.height / 2);

    final rectPath = Path()
      ..addRRect(RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        const Radius.circular(12),
      ));

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    final combinedPath = Path.combine(
      PathOperation.difference,
      rectPath,
      circlePath,
    );

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
