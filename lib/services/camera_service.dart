import 'dart:async';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  List<CameraDescription>? _cameras;
  CameraController? _controller;
  StreamController<CameraImage>? _imageStreamController;
  bool _isInitialized = false;
  bool _isRecording = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isRecording => _isRecording;
  CameraController? get controller => _controller;
  Stream<CameraImage>? get imageStream => _imageStreamController?.stream;

  // Initialize the camera service
  Future<void> initialize() async {
    // Request camera permission
    if (await Permission.camera.request().isDenied) {
      throw Exception('Camera permission denied');
    }

    // Get available cameras
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      throw Exception('No cameras available');
    }

    // Initialize the first camera (back camera)
    _controller = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
    _imageStreamController = StreamController<CameraImage>();
  }

  // Start camera preview
  void startPreview() {
    if (_controller != null && _isInitialized) {
      // Check if image stream is not already running
      _controller!.startImageStream((CameraImage image) {
        _imageStreamController?.add(image);
      });
    }
  }

  // Stop camera preview
  void stopPreview() {
    if (_controller != null) {
      // Stop image stream regardless of current state
      _controller!.stopImageStream();
    }
  }

  // Switch between front and back cameras
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentCamera = _controller!.description;
    final nextCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection != currentCamera.lensDirection,
      orElse: () => _cameras![0],
    );

    // Dispose current controller
    await _controller!.dispose();

    // Initialize new controller
    _controller = CameraController(
      nextCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
    startPreview();
  }

  // Toggle flash
  Future<void> toggleFlash() async {
    if (_controller == null || !_isInitialized) return;

    if (_controller!.value.flashMode == FlashMode.off) {
      await _controller!.setFlashMode(FlashMode.torch);
    } else {
      await _controller!.setFlashMode(FlashMode.off);
    }
  }

  // Start recording
  Future<void> startRecording() async {
    if (_controller == null || !_isInitialized || _isRecording) return;

    try {
      await _controller!.startVideoRecording();
      _isRecording = true;
    } catch (e) {
      print('Failed to start recording: $e');
      throw e;
    }
  }

  // Stop recording
  Future<XFile> stopRecording() async {
    if (_controller == null || !_isInitialized || !_isRecording) {
      throw Exception('Not recording');
    }

    try {
      final video = await _controller!.stopVideoRecording();
      _isRecording = false;
      return video;
    } catch (e) {
      print('Failed to stop recording: $e');
      throw e;
    }
  }

  // Capture photo
  Future<XFile> capturePhoto() async {
    if (_controller == null || !_isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      return await _controller!.takePicture();
    } catch (e) {
      print('Failed to capture photo: $e');
      throw e;
    }
  }

  // Dispose the camera service
  Future<void> dispose() async {
    stopPreview();
    _imageStreamController?.close();
    await _controller?.dispose();
    _isInitialized = false;
    _isRecording = false;
  }
}
