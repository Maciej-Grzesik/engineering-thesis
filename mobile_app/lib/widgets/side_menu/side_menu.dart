import 'package:flutter/material.dart';
import 'package:mobile_app/service/auth/auth_service.dart';
import 'package:mobile_app/widgets/side_menu/info_card.dart';
import 'package:mobile_app/widgets/side_menu/side_menu_tile.dart';
import 'package:mobile_app/pages_finished/home_page.dart';
import 'package:mobile_app/pages_finished/about_page.dart';
import 'package:mobile_app/pages/settings_page.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  final Function(Widget) onMenuItemSelected;

  const SideMenu({super.key, required this.onMenuItemSelected});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Home',
      'lottieAsset': 'assets/icons/home.json',
      'scale': 1.0,
      'page': const HomePage(),
    },
    {
      'title': 'About',
      'lottieAsset': 'assets/icons/about.json',
      'scale': 0.9,
      'page': const AboutPage(),
    },
    {
      'title': 'Settings',
      'lottieAsset': 'assets/icons/settings.json',
      'scale': 1.3,
      'page': const SettingsPage(),
    },
  ];

  AuthService _authService = AuthService();
  int _activeIndex = 0;
  bool _isLogout = false;

  void _setActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });

    widget.onMenuItemSelected(_menuItems[index]['page']);
  }

  void _setLogout() {
    setState(() {
      _isLogout = !_isLogout;
    });

    _authService.signout();
    Future.delayed(
      Durations.medium1,
      () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.themeDataStyle.colorScheme.secondaryContainer,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: SizedBox(
            width: 300,
            height: double.infinity,
            child: Column(
              children: [
                const InfoCard(name: "Test"),
                Divider(
                  color: context.colorScheme.tertiary,
                ),
                _buildMenuItems(),
                const Spacer(),
                Divider(
                  color: context.colorScheme.tertiary,
                ),
                SideMenuTile(
                  title: "Logout",
                  lottieAsset: 'assets/icons/logout.json',
                  isActive: _isLogout,
                  scale: 1,
                  onTap: _setLogout,
                ),
                Divider(
                  color: context.colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: _menuItems.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> menuItem = entry.value;

        return Column(
          children: [
            if (index > 0)
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 16.0,
                ),
                child: Divider(
                  color: context.colorScheme.outline,
                ),
              ),
            SideMenuTile(
              title: menuItem['title'],
              lottieAsset: menuItem['lottieAsset'],
              isActive: _activeIndex == index,
              scale: menuItem['scale'],
              onTap: () => _setActiveIndex(index),
            ),
          ],
        );
      }).toList(),
    );
  }
}
