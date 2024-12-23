import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class MeshGradientBackgroundPage extends StatelessWidget {
  const MeshGradientBackgroundPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Opacity(
              opacity: 1.0,
              child: AnimatedMeshGradient(
                colors: [
                  // themeProvider.themeDataStyle.colorScheme.onSecondary,
                  colorScheme.onSecondary,
                  colorScheme.inversePrimary,
                  colorScheme.inversePrimary,
                  colorScheme.onSecondary,
                ],
                options: AnimatedMeshGradientOptions(
                    speed: 0.01, amplitude: 30, grain: 0.1),
              ),
            ),
          ),
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}
