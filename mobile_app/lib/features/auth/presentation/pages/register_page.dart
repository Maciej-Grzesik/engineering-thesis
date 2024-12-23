import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/glass.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:mobile_app/features/auth/presentation/widgets/auth_input.dart';
import 'package:mobile_app/features/entry_point/presentation/pages/entry_point.dart';

class RegisterPage extends StatefulWidget {
    static route() => MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      );
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // final bool _isPasswordMismatch = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Hero(
      tag: 'auth-widget',
      child: MeshGradientBackgroundPage(
        child: Glass(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                PredefinedToast.showToast(state.message, ToastType.error);
              } else if (state is AuthSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryPoint(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                  child: Loader(),
                );
              }
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.create_account,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    AuthInput(
                      textEditingController: _emailController,
                      hintText: "email",
                      isObscureText: false,
                    ),
                    const Spacer(),
                    AuthInput(
                      textEditingController: _passwordController,
                      hintText: "password",
                      isObscureText: true,
                    ),
                    const Spacer(),
                    AuthInput(
                      textEditingController: _confirmPasswordController,
                      hintText: "confirm_password",
                      isObscureText: true,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthSignup(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.register,
                        style: TextStyle(
                            fontSize: 18, color: colorScheme.onPrimary),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: colorScheme.outline,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            AppLocalizations.of(context)!.or_continue_with,
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: colorScheme.outline,
                        )),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          color: colorScheme.primary,
                          icon: const Icon(Icons.g_mobiledata),
                          iconSize: 40,
                          onPressed: () {},
                        ),
                        IconButton(
                          color: colorScheme.primary,
                          icon: const Icon(Icons.apple),
                          iconSize: 40,
                          onPressed: () {},
                        ),
                        IconButton(
                          color: colorScheme.primary,
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
                          AppLocalizations.of(context)!.already_have_account,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.sign_in,
                            style: TextStyle(
                                color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
