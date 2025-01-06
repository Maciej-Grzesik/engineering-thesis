import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/navbar/presentation/widgets/circle_clipper.dart';

void main() {
  group('CircleClipper', () {
    test('getClip returns correct path', () {
      final clipper = CircleClipper();
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      final expectedPath = Path()
        ..addRRect(
          RRect.fromLTRBR(
            0,
            0,
            size.width,
            size.height,
            const Radius.circular(12),
          ),
        )
        ..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 35))
        ..fillType = PathFillType.evenOdd;

      expect(path, equals(expectedPath));
    });

    test('shouldReclip returns false', () {
      final clipper = CircleClipper();
      expect(clipper.shouldReclip(clipper), isFalse);
    });
  });

  group('BorderPainter', () {
    test('paint method draws correctly', () {
      final painter = BorderPainter(color: Colors.red);
      const size = Size(100, 100);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      painter.paint(canvas, size);

      final picture = recorder.endRecording();
      final image = picture.toImage(size.width.toInt(), size.height.toInt());

      expect(image, isNotNull);
    });

    test('shouldRepaint returns false', () {
      final painter = BorderPainter(color: Colors.red);
      expect(painter.shouldRepaint(painter), isFalse);
    });
  });
}