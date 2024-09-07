import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
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
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
        child: SizedBox.expand(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.8,
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: CameraPreview(
            cameraController!,
          ),
        ),
      ],
    )));
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController =
            CameraController(cameras.first, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }
}
