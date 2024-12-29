import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/core/common/widgets/glass.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app/features/_auth/presentation/pages/register_page.dart';
import 'package:mobile_app/features/_auth/presentation/widgets/auth_input.dart';
import 'package:mobile_app/features/entry_point/presentation/pages/entry_point.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
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
                //rembember to create custom loading widget later
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
                      l10n.hello_again,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 16),
                    ),
                    Text(
                      l10n.welcome_back,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorScheme.onSurfaceVariant, fontSize: 14),
                    ),
                    const Spacer(),
                    AuthInput(
                      textEditingController: _emailController,
                      hintText: "email",
                      isObscureText: false,
                    ),
                    const SizedBox(height: 16),
                    AuthInput(
                      textEditingController: _passwordController,
                      hintText: "password",
                      isObscureText: true,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.recovery_password,
                          style: TextStyle(color: colorScheme.secondary),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
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
                        l10n.sign_in,
                        style: TextStyle(
                            fontSize: 18, color: colorScheme.onPrimary),
                      ),
                    ),
                    // const SizedBox(height: 12),
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
                            l10n.or_continue_with,
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
                          l10n.not_a_member,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            RegisterPage.route(),
                          ),
                          child: Text(
                            l10n.register_now,
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
