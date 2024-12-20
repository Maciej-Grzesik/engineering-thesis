import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/utils/mesh_gradient_background.dart';
import 'package:mobile_app/service/user/user_service.dart';
import 'package:mobile_app/utils/theme_provider.dart';

class UpdateUserDataPage extends StatefulWidget {
  const UpdateUserDataPage({super.key});

  @override
  State<UpdateUserDataPage> createState() => _UpdateUserDataPageState();
}

class _UpdateUserDataPageState extends State<UpdateUserDataPage> {
  final _usernameController = TextEditingController();
  final _userInfoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService(); // Twój serwis użytkownika

  Future<void> _updateUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _userService.addUserInfo(
          _usernameController.text.trim(),
          _userInfoController.text.trim(),
        );
        // Cofnij do pierwszej strony w stosie nawigacyjnym
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user info: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeshGradientBackgroundPage(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
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
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please enter your username and additional information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: context.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Username cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _userInfoController,
                          decoration: InputDecoration(
                            labelText: "Additional Info",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Additional Info cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateUserData,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Continue"),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_circle_right_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
