import 'dart:math';
import 'package:flutter/material.dart';

import 'package:mobile_app/.rewriting/models/utils/open_menu_gesture.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/features/camera/camera.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/menu_button.dart';
import 'package:mobile_app/features/home_page/home_page.dart';
import 'package:mobile_app/features/navbar/navbar/custom_floating_action_button.dart';
import 'package:mobile_app/features/navbar/navbar/navigation_bar.dart';
import 'package:mobile_app/features/side_menu/side_menu/side_menu.dart';

class EntryPoint extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );

  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  bool _isCameraPage = false;
  bool isMenuOpen = false;

  final List<Widget> _pageStack = [const HomePage()];
  Widget _currentPage = const HomePage();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCameraPage() {
    setState(() {
      _isCameraPage = !_isCameraPage;
    });
  }

  void _updatePage(Widget page) {
    setState(() {
      _currentPage = page;
      _pageStack.add(page);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isMenuOpen = false;
      });
      _animationController.reverse();
    });
  }

  void _goBack() {
    if (_pageStack.length > 1) {
      setState(() {
        _pageStack.removeLast();
        _currentPage = _pageStack.last;
      });
    } else {
      PredefinedToast.showToast("There's nowhere to go back!", ToastType.error);
    }
  }

  bool isRecording = false;
  void _startRecording() {
    setState(() {
      isRecording = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: OpenMenuGestureDetector(
        onOpenMenu: () {
          if (!isMenuOpen) {
            _animationController.forward();
            setState(() {
              isMenuOpen = true;
            });
          }
        },
        onCloseMenu: () {
          if (isMenuOpen) {
            _animationController.reverse();
            setState(() {
              isMenuOpen = false;
            });
          }
        },
        child: Scaffold(
          backgroundColor: colorScheme.secondaryContainer,
          extendBody: true,
          body: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                width: 288,
                left: isMenuOpen ? 0 : -288,
                height: MediaQuery.of(context).size.height,
                child: SideMenu(
                  onMenuItemSelected: _updatePage,
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(
                      _animation.value - 30 * _animation.value * pi / 180),
                child: Transform.translate(
                  offset: Offset(_animation.value * 288, 0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: _isCameraPage
                          ? const CameraPage()
                          : MeshGradientBackgroundPage(child: _currentPage),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                top: 16,
                left: isMenuOpen ? 220 : 0,
                child: MenuButton(
                  isMenuOpen: isMenuOpen,
                  press: () {
                    if (isMenuOpen) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }
                    setState(() {
                      isMenuOpen = !isMenuOpen;
                    });
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: Transform.translate(
            offset: Offset(0, 150 * _animation.value),
            child: CustomFloatingActionButton(
              isCameraPage: _isCameraPage,
              onPressed: _toggleCameraPage,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Transform.translate(
            offset: Offset(0, 150 * _animation.value - 36),
            child: CustomNavigationBar(
              onBackPressed: _goBack,
              isCameraPage: _isCameraPage,
              startRecording: _startRecording,
            ),
          ),
        ),
      ),
    );
  }
}
