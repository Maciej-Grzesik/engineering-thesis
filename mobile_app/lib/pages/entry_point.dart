import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/widgets/side_menu/side_menu.dart';
import 'package:mobile_app/pages/home_page.dart';
import 'package:mobile_app/pages/about_page.dart';
import 'package:mobile_app/pages/mesh_gradient_background.dart';
import 'package:mobile_app/pages/settings_page.dart';
import 'package:mobile_app/pages/menu_button.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'camera.dart';
import 'custom_floating_action_button.dart';
import 'package:mobile_app/pages/navigation_bar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  bool _isCameraPage = false;
  bool isMenuOpen = false;

  final List<Widget> _pageStack = [const HomePage()];
  Widget _currentPage = const HomePage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    _controller.dispose();
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
      _controller.reverse();
    });
  }

  void _goBack() {
    debugPrint('Aktualna strona: ${_currentPage}');
    if (_pageStack.length > 1) {
      setState(() {
        _pageStack.removeLast();
        _currentPage = _pageStack.last;
      });
    debugPrint('Strona poprzednia: ${_currentPage}');
    } else {
      Fluttertoast.showToast(
        msg: "Nie ma dokąd wrócić!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.localPosition.dx < 100) {
          if (details.delta.dx > 100 && !isMenuOpen) {
            _controller.forward();
            setState(() {
              isMenuOpen = true;
            });
          } else if (details.delta.dx < 0 && isMenuOpen) {
            _controller.reverse();
            setState(() {
              isMenuOpen = false;
            });
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (isMenuOpen && details.primaryVelocity! < -200) {
          _controller.reverse();
          setState(() {
            isMenuOpen = false;
          });
        } else if (!isMenuOpen && details.primaryVelocity! > 200) {
          _controller.forward();
          setState(() {
            isMenuOpen = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor:
            themeProvider.themeDataStyle.colorScheme.secondaryContainer,
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
                ..rotateY(_animation.value - 30 * _animation.value * pi / 180),
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
                    _controller.reverse();
                  } else {
                    _controller.forward();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Transform.translate(
          offset: Offset(0, 150 * _animation.value - 36),
          child: CustomNavigationBar(
            onBackPressed: _goBack,
          ),
        ),
      ),
    );
  }
}
