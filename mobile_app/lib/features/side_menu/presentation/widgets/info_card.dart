import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/_user/presentation/pages/user_profile.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/l10n/l10n.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        context.read<NavbarBloc>().add(
              const PushPage(
                UserProfile(),
              ),
            );
        context.read<SideMenuBloc>().add(
              OnMenuToggle(),
            );
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserSuccess) {
            return ListTile(
              leading: const CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(state.userProfile.name),
              subtitle: Text(state.userProfile.email),
            );
          } else if (state is UserFailure) {
            return ListTile(
              leading: const CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(
                l10n.error,
                style: const TextStyle(color: Colors.red),
              ),
              subtitle: Text(
                l10n.failed_to_load_data,
                style: const TextStyle(color: Colors.black54),
              ),
            );
          } else {
            return ListTile(
              leading: const CircleAvatar(
                child: ClipOval(
                  child: MeshGradientBackgroundPage(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(l10n.loading),
              subtitle: Text(
                l10n.please_wait,
                style: const TextStyle(color: Colors.black54),
              ),
            );
          }
        },
      ),
    );
  }
}
