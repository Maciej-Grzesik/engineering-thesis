import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/glass.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/l10n/l10n.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return MeshGradientBackgroundPage(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserSuccess) {
              return Glass(
                wrapContent: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.user_profile,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Divider(color: colorScheme.tertiary),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("${l10n.name}: ${state.userProfile.name}"),
                      subtitle: Text("E-mail: ${state.userProfile.email}"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () {
                          _showEditDialog(context, state.userProfile.name,
                              state.userProfile.email);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserFailure) {
              return Center(
                child: Text(
                  l10n.failed_to_load_data,
                  style: TextStyle(color: colorScheme.error),
                ),
              );
            } else {
              return Center(child: Text(l10n.loading));
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, String currentName, String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(UpdateUserProfile(
                      name: nameController.text,
                      email: emailController.text,
                    ));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
