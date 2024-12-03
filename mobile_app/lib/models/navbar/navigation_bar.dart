import 'package:flutter/material.dart';
import 'package:mobile_app/models/utils/circle_clipper.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          ClipPath(
            clipper: CircleClipper(),
            child: Container(
              color: themeProvider.themeDataStyle.colorScheme.surface
                  .withOpacity(0.6),
              height: 50,
              width: double.infinity,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 35,
                  ),
                  onPressed: () {},
                  color: themeProvider.themeDataStyle.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 70),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: themeProvider.themeDataStyle.colorScheme.onSurface,
                  ),
                  onPressed: () => widget.onBackPressed(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


