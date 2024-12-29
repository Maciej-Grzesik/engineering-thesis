import 'package:flutter/material.dart';
import 'package:mobile_app/.rewriting/models/utils/circle_clipper.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {super.key,
      required this.onBackPressed,
      required this.isCameraPage,
      required this.startRecording});

  final VoidCallback onBackPressed;
  final bool isCameraPage;
  final VoidCallback startRecording;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(
              double.infinity,
              20,
            ),
            painter: BorderPainter(
              color: colorScheme.outline.withOpacity(0.3),
            ),
            child: ClipPath(
              clipper: CircleClipper(),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.6),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.not_started_outlined,
                    size: 35,
                  ),
                  onPressed: () {
                    if (!widget.isCameraPage) {
                      PredefinedToast.showToast(
                        "Currently not on camera page",
                        ToastType.error,
                      );
                    } else {
                      widget.startRecording();
                    }
                  },
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 70),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: colorScheme.onSurface,
                  ),
                  onPressed: () => widget.onBackPressed(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
