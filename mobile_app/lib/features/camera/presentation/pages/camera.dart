import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/common/widgets/mesh_gradient_background.dart';
import 'package:mobile_app/features/camera/presentation/widgets/countdown_overlay.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  bool isRecording = false;
  String pred = "";
  List<Uint8List> capturedFrames = [];
  Uint8List img = Uint8List.fromList([]);

  void _startRecordingCountdown() {
    setState(() {
      isRecording = true;
    });
  }

  Future<void> _startRecording() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      setState(() {
        isRecording = true;
      });

      try {
        await cameraController?.startVideoRecording();

        await Future.delayed(const Duration(seconds: 3));

        final XFile? videoFile = await cameraController?.stopVideoRecording();

        if (videoFile != null) {
          final Uint8List videoBytes = await videoFile.readAsBytes();

          await _sendVideoToEndpoint(videoBytes);
        }
      } catch (e) {
        throw Exception('Failed to record video: $e');
      } finally {
        setState(() {
          isRecording = false;
        });
      }
    }
  }

  Future<void> _sendVideoToEndpoint(Uint8List videoBytes) async {
    try {
      String base64Video = base64Encode(videoBytes);

      final response = await http.post(
        Uri.parse('http://192.168.0.9:6000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'video': base64Video}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // final prediction = data['prediction'];
        final word = data['word'];
        
        setState(() {
          pred = word;
        });
      } else {
        
      }
    } catch (e) {
      throw Exception('Failed to send video to endpoint: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: isRecording ? null : _startRecordingCountdown,
        child: const Icon(Icons.videocam),
      ),
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const MeshGradientBackgroundPage(
          child: CircularProgressIndicator());
    }
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
        if (isRecording)
          CountdownOverlay(
            onCountdownComplete: () {
              _startRecording();
            },
          ),
      ],
    );
  }

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
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
