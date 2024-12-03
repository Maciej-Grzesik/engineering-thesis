import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutTile extends StatefulWidget {
  const AboutTile({super.key, required double screenWidth, required double screenHeight, required double padding, required int currentPage, required int pageCount, required PageController pageController});

  @override
  State<AboutTile> createState() => _AboutTileState();
}

class _AboutTileState extends State<AboutTile>  with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAnimation,
      child: ListTile(
        leading: SizedBox(
          height: 34,
          width: 34,
          child: Lottie.asset(
            'assets/icons/about.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.value = 1.0;
            },
          ),
        ),
        title: const Text(
          "About",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
