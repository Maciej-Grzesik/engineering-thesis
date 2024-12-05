import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class MeshGradientBackgroundPage extends StatelessWidget {
  const MeshGradientBackgroundPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                  themeProvider.themeDataStyle.colorScheme.onSecondary,
                  themeProvider.themeDataStyle.colorScheme.inversePrimary,
                  themeProvider.themeDataStyle.colorScheme.inversePrimary,
                  themeProvider.themeDataStyle.colorScheme.onSecondary,
                ],
                options: AnimatedMeshGradientOptions(speed: 0.01),
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
