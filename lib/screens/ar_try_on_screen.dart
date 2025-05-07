
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';


class PseudoARViewScreen extends StatefulWidget {
  const PseudoARViewScreen({super.key});

  @override
  State<PseudoARViewScreen> createState() => _PseudoARViewScreenState();
}

class _PseudoARViewScreenState extends State<PseudoARViewScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere((camera) =>
    camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Псевдо-AR')),
      body: !_isCameraInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          CameraPreview(_cameraController),
          Center(
            child: Cube(
              onSceneCreated: (Scene scene) {
                scene.world.add(Object(
                  scale: Vector3(2.0, 2.0, 2.0),
                  position: Vector3(0, 0, 0),
                  fileName: 'assets/images/tt.obj',
                ));
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Закрыть"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
