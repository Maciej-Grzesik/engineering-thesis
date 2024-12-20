import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/models/utils/mesh_gradient_background.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

class LoginPageWidget extends StatefulWidget {
  final VoidCallback handleSignIn;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback goToRegisterPage;

  const LoginPageWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.handleSignIn,
    required this.goToRegisterPage,
  });

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  bool _isPasswordVisible = false;

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
                        horizontal: 24, vertical: 32),
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: verticalMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.hello_again,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSurface,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.welcome_back,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: widget.emailController,
                          style:
                              TextStyle(color: context.colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.email,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.colorScheme.outline),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.colorScheme.surface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: widget.passwordController,
                          style:
                              TextStyle(color: context.colorScheme.onSurface),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.password,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.colorScheme.outline),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.colorScheme.surface,
                            suffixIcon: IconButton(
                              color: context.colorScheme.onSurface,
                              icon: _isPasswordVisible
                                  ? const Icon(Icons.visibility_rounded)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        // const SizedBox(height: 8),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.recovery_password,
                              style: TextStyle(
                                  color: context.colorScheme.secondary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: widget.handleSignIn,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: context.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.sign_in,
                            style: TextStyle(
                                fontSize: 18,
                                color: context.colorScheme.onPrimary),
                          ),
                        ),
                        // const SizedBox(height: 12),
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
                              AppLocalizations.of(context)!.not_a_member,
                              style: TextStyle(
                                  color: context.colorScheme.onSurface),
                            ),
                            TextButton(
                              onPressed: widget.goToRegisterPage,
                              child: Text(
                                AppLocalizations.of(context)!.register_now,
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
