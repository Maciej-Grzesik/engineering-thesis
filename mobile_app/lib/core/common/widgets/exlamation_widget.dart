import 'package:flutter/material.dart';

class ExlamationWidget extends StatefulWidget {
  final Widget route;
  const ExlamationWidget({super.key, required this.route});

  @override
  State<ExlamationWidget> createState() => _ExlamationWidgetState();
}

class _ExlamationWidgetState extends State<ExlamationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _rotationController.repeat(reverse: true);
    });
  }

  void startScaleAnimation() {
    _scaleController.repeat(reverse: true);
  }

  void stopScaleAnimation() {
    _scaleController.stop();
  }

  void startRotationAnimation() {
    _rotationController.repeat(reverse: true);
  }

  void stopRotationAnimation() {
    _rotationController.stop();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (_scaleController.isAnimating) {
            stopScaleAnimation();
            stopRotationAnimation();
          } else {
            startScaleAnimation();
            startRotationAnimation();
          }

          Navigator.push<void>(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => widget.route,
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleController, _rotationController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outline,
                    ),
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow,
                        offset: const Offset(1, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
