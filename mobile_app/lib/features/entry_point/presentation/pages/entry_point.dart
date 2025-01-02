import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/util/open_menu_gesture.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';

import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/features/camera/presentation/pages/camera.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/menu_button.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/widgets/custom_floating_action_button.dart';
import 'package:mobile_app/features/navbar/presentation/widgets/navigation_bar.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/side_menu.dart';

class EntryPoint extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );

  const EntryPoint({
    super.key,
  });

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    context.read<NavbarBloc>().add(const PushPage(HomePage()));

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<SideMenuBloc, SideMenuState>(
        listener: (context, state) => {
              if (state is SideMenuExtended)
                {
                  _animationController.forward(),
                }
              else if (state is SideMenuCollapsed)
                {
                  _animationController.reverse(),
                }
            },
        builder: (context, state) {
          return PopScope(
            canPop: false,
            child: OpenMenuGestureDetector(
              onOpenMenu: () {
                if (state is SideMenuCollapsed) {
                  context.read<SideMenuBloc>().add(OnMenuToggle());
                }
              },
              onCloseMenu: () {
                if (state is SideMenuExtended) {
                  context.read<SideMenuBloc>().add(OnMenuToggle());
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
                      left: state is SideMenuExtended ? 0 : -288,
                      height: MediaQuery.of(context).size.height,
                      child: const SideMenu(),
                    ),
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value -
                            30 * _animation.value * pi / 180),
                      child: Transform.translate(
                        offset: Offset(_animation.value * 288, 0),
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              child:
                                  BlocBuilder<EntryPointBloc, EntryPointState>(
                                builder: (context, state) {
                                  if (state is CameraPageOn) {
                                    return const CameraPage();
                                  } else {
                                    return MeshGradientBackgroundPage(
                                      child:
                                          BlocConsumer<NavbarBloc, NavbarState>(
                                        listener: (context, state) {
                                          if (state is GoBackFailure) {
                                            PredefinedToast.showToast(
                                                state.error, ToastType.error);
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is PushPageSuccess) {
                                            return state.pageStack.last;
                                          } else if (state is GoBackSuccess) {
                                            return state.pageStack.last;
                                          } else if (state is GoBackFailure) {
                                            return state.pageStack.last;
                                          } else {
                                            return const Loader();
                                          }
                                        },
                                      ),
                                    );
                                  }
                                },
                              )),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      top: 16,
                      left: state is SideMenuExtended ? 220 : 0,
                      child: MenuButton(
                        isMenuOpen: state is SideMenuExtended,
                        press: () {
                          context.read<SideMenuBloc>().add(OnMenuToggle());
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Transform.translate(
                  offset: Offset(0, 150 * _animation.value),
                  child: const CustomFloatingActionButton(),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: Transform.translate(
                  offset: Offset(0, 150 * _animation.value - 36),
                  child: const CustomNavigationBar(),
                ),
              ),
            ),
          );
        });
  }
}
