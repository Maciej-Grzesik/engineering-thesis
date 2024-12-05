import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/utils/mesh_gradient_background.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/pages/entry_point.dart';
import 'package:mobile_app/service/auth/auth_service.dart';
import 'package:mobile_app/utils/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordMismatch = false;

  final _authService = AuthService();

  Future<void> _handleRegister() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool isValidEmail(String email) {
      const emailRegex = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
      return RegExp(emailRegex).hasMatch(email);
    }

    try {
      final user =
          await _authService.createUserWithEmailAndPassword(email, password);

      if (user != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryPoint(),
            ),
          );
        }
      }

      debugPrintStack(label: "Current user email: ${user!.email}");
    } catch (e) {
      //implement on ui
    }
  }


  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'auth-widget',
      child: MeshGradientBackgroundPage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalMargin = constraints.maxWidth * 0.1;
            final verticalMargin = constraints.maxHeight * 0.1;

            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.secondary.withOpacity(0.1),
                          context.colorScheme.tertiary.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: verticalMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.welcome,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.create_account,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.email,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.colorScheme.surface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.colorScheme.surface,
                            suffixIcon: IconButton(
                              icon: _isPasswordVisible
                                  ? const Icon(Icons.visibility_rounded)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            errorText: _isPasswordMismatch
                                ? AppLocalizations.of(context)!
                                    .password_mismatch
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.colorScheme.error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isPasswordMismatch = _passwordController.text !=
                                  _confirmPasswordController.text;
                            });
                          },
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.confirm_password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.colorScheme.surface,
                            suffixIcon: IconButton(
                              icon: _isConfirmPasswordVisible
                                  ? const Icon(Icons.visibility_rounded)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            errorText: _isPasswordMismatch
                                ? AppLocalizations.of(context)!
                                    .password_mismatch
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.colorScheme.error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              setState(() {
                                _isPasswordMismatch = true;
                              });
                            } else {
                              setState(() {
                                _isPasswordMismatch = false;
                              });

                              _handleRegister();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: context.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.register,
                            style: TextStyle(
                                fontSize: 18,
                                color: context.colorScheme.onPrimary),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              color: context.colorScheme.outline,
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                AppLocalizations.of(context)!.or_continue_with,
                                style: TextStyle(
                                    color: context.colorScheme.onSurface),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              color: context.colorScheme.outline,
                            )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              color: context.colorScheme.primary,
                              icon: const Icon(Icons.g_mobiledata),
                              iconSize: 40,
                              onPressed: () {},
                            ),
                            IconButton(
                              color: context.colorScheme.primary,
                              icon: const Icon(Icons.apple),
                              iconSize: 40,
                              onPressed: () {},
                            ),
                            IconButton(
                              color: context.colorScheme.primary,
                              icon: const Icon(Icons.facebook),
                              iconSize: 40,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .already_have_account,
                              style: TextStyle(
                                  color: context.colorScheme.onSurface),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.sign_in,
                                style: TextStyle(
                                    color:
                                        context.colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
