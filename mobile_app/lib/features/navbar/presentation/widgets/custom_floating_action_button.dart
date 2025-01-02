import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({
    super.key,
  });

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<EntryPointBloc, EntryPointState>(
      builder: (context, state) {
        return FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: colorScheme.primary,
          onPressed: () {
            context.read<EntryPointBloc>().add(
                  ToggleCameraPage(),
                );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              state is CameraPageOn ? Icons.clear : Icons.camera_alt,
              key: ValueKey<bool>(state is CameraPageOn),
              color: colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}