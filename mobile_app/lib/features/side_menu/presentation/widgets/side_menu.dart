import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/_about/presentation/pages/about_page.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/_settings/presentation/pages/settings_page.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/info_card.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/side_menu_tile.dart';
import 'package:mobile_app/l10n/l10n.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<Map<String, dynamic>> _menuItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _menuItems.addAll([
      {
        'title': AppLocalizations.of(context)!.home,
        'lottieAsset': 'assets/icons/home.json',
        'scale': 1.0,
        'page': const HomePage(),
      },
      {
        'title': AppLocalizations.of(context)!.about,
        'lottieAsset': 'assets/icons/about.json',
        'scale': 0.9,
        'page': const AboutPage(),
      },
      {
        'title': AppLocalizations.of(context)!.setting,
        'lottieAsset': 'assets/icons/settings.json',
        'scale': 1.3,
        'page': const SettingsPage(),
      },
    ]);
  }

  int _activeIndex = 0;

  void _setActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
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
                    const InfoCard(),
                    Divider(
                      color: colorScheme.tertiary,
                    ),
                    _buildMenuItems(),
                    const Spacer(),
                    Divider(
                      color: colorScheme.tertiary,
                    ),
                    SideMenuTile(
                      title: l10n.logout,
                      lottieAsset: 'assets/icons/logout.json',
                      isActive: false,
                      scale: 1,
                      onTap: () {
                        context.read<UserBloc>().add(
                              LogoutEvent(),
                            );
                        context.read<SideMenuBloc>().add(OnMenuToggle());
                      },
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
      },
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
                context.read<NavbarBloc>().add(
                      PushPage(_menuItems[index]['page']),
                    ),
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    context.read<SideMenuBloc>().add(OnMenuToggle());
                  }
                })
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
