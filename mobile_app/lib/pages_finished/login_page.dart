import 'package:flutter/material.dart';
import 'package:mobile_app/models/login_widgets/login_page_widget.dart';
import '../pages/login_page_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onSignIn() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showError("Please fill in all fields");
    } else {
      // Add your login logic here
      print("Logging in with username: $username and password: $password");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageWidget(
      usernameController: _usernameController,
      passwordController: _passwordController,
      isPasswordVisible: _isPasswordVisible,
      onPasswordToggle: _togglePasswordVisibility,
      onSignIn: _onSignIn,
    );
  }
}
