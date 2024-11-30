import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 35.0;
    final center = Offset(size.width / 2, size.height / 2);

    path.addRRect(RRect.fromLTRBR(
        0, 0, size.width, size.height, const Radius.circular(12)));
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
