import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/_about/presentation/pages/about_page.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/_settings/presentation/pages/settings_page.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/side_menu/info_card.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/side_menu/side_menu_tile.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/user/presentation/pages/user_profile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

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

  int _activeIndex = 0;
  bool _isLogout = false;

  void _setActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  void _setLogout() {
    setState(() {
      _isLogout = !_isLogout;
    });

    // _authService.signout();
    Future.delayed(
      Durations.medium1,
      () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.secondaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: SizedBox(
            width: 300,
            height: double.infinity,
            child: Column(
              children: [
                InfoCard(
                    name: "Test",
                    onTap: () {
                      context.read<NavbarBloc>().add(
                            const PushPage(
                              UserProfile(),
                            ),
                          );
                    }),
                Divider(
                  color: colorScheme.tertiary,
                ),
                _buildMenuItems(),
                const Spacer(),
                Divider(
                  color: colorScheme.tertiary,
                ),
                SideMenuTile(
                  title: "Logout",
                  lottieAsset: 'assets/icons/logout.json',
                  isActive: _isLogout,
                  scale: 1,
                  onTap: _setLogout,
                ),
                Divider(
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.outline,
                ),
              ),
            SideMenuTile(
              title: menuItem['title'],
              lottieAsset: menuItem['lottieAsset'],
              isActive: _activeIndex == index,
              scale: menuItem['scale'],
              onTap: () => {
                _setActiveIndex(index),
                context
                    .read<NavbarBloc>()
                    .add(PushPage(_menuItems[index]['page']))
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
