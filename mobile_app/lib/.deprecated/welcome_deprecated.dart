import 'package:flutter/material.dart';
import 'package:mobile_app/pages/entry_point.dart';

class WelcomePage extends StatefulWidget {
  final String title;

  const WelcomePage({
    super.key,
    required this.title,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  double _opacity = 0.0;

  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> animation = CurvedAnimation(
      parent: animationController, curve: Curves.easeInOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
      animationController.forward().then((_) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const EntryPoint()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 1000),
            child: const Text("Welcome!"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
