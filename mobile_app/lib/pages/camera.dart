import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/mesh_gradient_background.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const MeshGradientBackgroundPage(child: CircularProgressIndicator());
    }
    return SizedBox.expand(
      child: CameraPreview(cameraController!),
    );
  }

  Future<void> _setupCameraController() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameraController = CameraController(cameras.first, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
