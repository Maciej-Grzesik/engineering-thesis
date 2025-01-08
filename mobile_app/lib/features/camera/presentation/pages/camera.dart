import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:mobile_app/features/camera/presentation/widgets/countdown_overlay.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  String pred = "";
  List<Uint8List> capturedFrames = [];
  Uint8List img = Uint8List.fromList([]);

  Future<void> _setupCameraController() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameraController =
            CameraController(cameras.first, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<String> _startRecording() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        await cameraController?.startVideoRecording();

        await Future.delayed(const Duration(seconds: 3));

        final XFile? videoFile = await cameraController?.stopVideoRecording();

        if (videoFile == null) {
          throw Exception("Error");
        }

        final Uint8List videoBytes = await videoFile.readAsBytes();

        return base64Encode(videoBytes);
      } catch (e) {
        throw Exception('Failed to record video: $e');
      }
    }
    throw Exception('Camera is not initialized');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavbarBloc, NavbarState>(
      listener: (context, state) {
        if (state is NavbarSuccess) {
          context.read<CameraBloc>().add(StartRecordingEvent());
        }
      },
      child: Scaffold(
        body: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const MeshGradientBackgroundPage(
        child: Loader(),
      );
    }
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(cameraController!)),
        Align(
          alignment: Alignment.center,
          child: Text(
            pred,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            if (state is CameraRecording) {
              return CountdownOverlay(
                onCountdownComplete: () async {
                  final b64Video = await _startRecording();
                  if (context.mounted) {
                    print("zaczynamy");
                    context.read<CameraBloc>().add(
                          ClassificationEvent(b64Video: b64Video),
                        );
                    context.read<CameraBloc>().add(
                          StopRecordingEvent(),
                        );
                  }
                },
              );
            } else if (state is CameraSucces) {
              return Positioned(
                bottom: 150,
                right: 50,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Predicted word: ${state.classification.word}",
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else if (state is CameraFailure) {
              return const SizedBox();
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
