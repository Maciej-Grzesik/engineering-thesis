import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/utils/mesh_gradient_background.dart';
import 'package:mobile_app/pages/fill_user_data.dart';
import 'package:mobile_app/utils/theme_provider.dart';

class MissingUserDataWidget extends StatefulWidget {
  const MissingUserDataWidget({super.key});

  @override
  State<MissingUserDataWidget> createState() => _MissingUserDataWidgetState();
}

class _MissingUserDataWidgetState extends State<MissingUserDataWidget> {
  @override
  Widget build(BuildContext context) {
    return MeshGradientBackgroundPage(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colorScheme.secondary.withOpacity(0.1),
                        context.colorScheme.tertiary.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Help us",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "by filling your profile information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: context.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_circle_left_outlined,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Go back "),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const UpdateUserDataPage(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Continue"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_circle_right_outlined,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
