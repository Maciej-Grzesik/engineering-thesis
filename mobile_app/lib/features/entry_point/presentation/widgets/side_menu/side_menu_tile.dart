import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SideMenuTile extends StatefulWidget {
  final String title;
  final String lottieAsset;
  final bool isActive;
  final double scale;
  final VoidCallback? onTap;

  const SideMenuTile({
    required this.title,
    required this.lottieAsset,
    required this.isActive,
    required this.scale,
    this.onTap,
    super.key,
  });

  @override
  State<SideMenuTile> createState() => _SideMenuTileState();
}

class _SideMenuTileState extends State<SideMenuTile>
    with SingleTickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        _playAnimation();
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Column(
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(left: 12.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 1,
          //   ),
          // ),
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                height: 56,
                width: widget.isActive ? 280 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Transform.scale(
                    scale: widget.scale,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        widget.isActive
                            ? colorScheme.onPrimary
                            : colorScheme.onSecondaryContainer,
                        BlendMode.srcIn,
                      ),
                      child: Lottie.asset(
                        widget.lottieAsset,
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller.duration =
                              const Duration(milliseconds: 700);
                          _controller.forward();
                        },
                      ),
                    ),
                  ),
                ),
                title: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: widget.isActive
                        ? colorScheme.onPrimary
                        : colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(widget.title),
                ),
                // tileColor: widget.isActive ? Colors.blue.shade50 : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
