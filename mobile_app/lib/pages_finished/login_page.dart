import 'package:flutter/material.dart';
import 'package:mobile_app/models/login_widgets/login_page_widget.dart';
import 'package:mobile_app/models/toasts/predefined_toast.dart';
import 'package:mobile_app/pages/entry_point.dart';
import 'package:mobile_app/pages/register_page.dart';
import 'package:mobile_app/service/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool isValidEmail(String email) {
      const emailRegex = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
      return RegExp(emailRegex).hasMatch(email);
    }

    if (!isValidEmail(email)) {
      PredefinedToast.showToast("test", ToastType.error);
      return;
    }

    try {
      final user =
          await _authService.loginUserWithEmailAndPassword(email, password);

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

  void _goToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageWidget(
      handleSignIn: _handleSignIn,
      goToRegisterPage: () => _goToRegisterPage(context),
      emailController: _emailController,
      passwordController: _passwordController,
    );
  }
}
