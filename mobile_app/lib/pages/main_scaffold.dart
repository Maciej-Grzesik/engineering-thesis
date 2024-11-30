import 'package:flutter/material.dart';
import 'package:mobile_app/pages/camera.dart';
import 'package:mobile_app/pages/entry_point.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String _currentRoute = '/home';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Navigator(
        initialRoute: _currentRoute,
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (settings.name) {
            case '/camera':
              page = const CameraPage();
              break;
            case '/home':
              page = const EntryPoint();
              break;
            default:
              page = const EntryPoint();
          }

          return MaterialPageRoute(
            builder: (_) => page,
            settings: settings,
          );
        },
      ),
      extendBody: true,
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: FloatingActionButton(
          key: ValueKey<String>(_currentRoute),
          shape: const CircleBorder(),
          backgroundColor: colorScheme.primaryContainer,
          onPressed: () {
            setState(() {
              if (_currentRoute == '/home') {
                _currentRoute = '/camera';
                Navigator.pushNamed(context,
                    '/camera');
              } else if (_currentRoute == '/camera') {
                _currentRoute = '/home';
                Navigator.pushNamed(context, '/home');
              }
            });
          },
          child: Icon(
            _currentRoute == '/home' ? Icons.camera_alt : Icons.clear,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const Drawer(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 60,
        color: colorScheme.primaryContainer,
        notchMargin: 7,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 35,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                color: colorScheme.onPrimaryContainer,
              );
            }),
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              color: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
