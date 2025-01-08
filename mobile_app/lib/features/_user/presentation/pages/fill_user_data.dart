import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/glass.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';

class UpdateUserDataPage extends StatefulWidget {
  const UpdateUserDataPage({super.key});

  @override
  State<UpdateUserDataPage> createState() => _UpdateUserDataPageState();
}

class _UpdateUserDataPageState extends State<UpdateUserDataPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MeshGradientBackgroundPage(
      child: Form(
        key: _formKey,
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              Navigator.pop(context);
              Navigator.pop(context);
            } else if (state is UserFailure) {
              PredefinedToast.showToast(state.message, ToastType.error);
            }
          },
          child: Glass(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Update Profile",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter your username and additional information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onSurface,
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Additional information",
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
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UpdateUserProfile(
                            email: _emailController.text.trim(),
                            name: _usernameController.text.trim(),
                          ),
                        );
                  },
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
    );
  }
}
