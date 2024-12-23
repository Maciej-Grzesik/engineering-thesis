import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/.rewriting/service/user/user_service.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/missing_data_button.dart';

class HomePageWidget extends StatelessWidget {
  HomePageWidget({super.key});

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _userService.getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading user data"));
              } else if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!;
                final username = userData['username'] as String?;
                final userInfo = userData['userInfo'] as String?;

                final isDataMissing = (username == null || username.isEmpty) ||
                    (userInfo == null || userInfo.isEmpty);

                if (isDataMissing) {
                  return const Positioned(
                    top: 16,
                    right: 0,
                    child: MissingDataButton(),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const Positioned(
                  top: 16,
                  right: 0,
                  child: MissingDataButton(),
                );
              }
            },
          ),
          Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary.withOpacity(0.1),
                          colorScheme.tertiary.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "to the Sign Language Recognition App",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
