import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutCard extends StatefulWidget {
  const AboutCard({super.key});

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard>  with SingleTickerProviderStateMixin {
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
