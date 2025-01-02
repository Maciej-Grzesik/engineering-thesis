import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/glass.dart';
import 'package:mobile_app/core/common/widgets/predefined_toast.dart';
import 'package:mobile_app/core/utils/get_error_code.dart';
import 'package:mobile_app/core/common/widgets/exlamation_widget.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/_user/presentation/pages/user_continue_data.dart';
import 'package:mobile_app/l10n/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const GetUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Positioned(
                  top: 16,
                  right: 0,
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserFailure) {
                return const Positioned(
                  top: 16,
                  right: 0,
                  child: ExlamationWidget(route: MissingUserDataWidget()),
                );
              } else if (state is UserSuccess) {
                return const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          Glass(
            wrapContent: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.welcome,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.home_page,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
