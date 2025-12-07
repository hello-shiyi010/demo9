import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final CameraService _cameraService = CameraService();
  final AudioService _audioService = AudioService();
  bool _isCameraInitialized = false;
  bool _isAudioInitialized = false;
  double _volume = 0.5;
  String _selectedDevice = '摄像头 1';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  // Initialize camera and audio services
  Future<void> _initializeServices() async {
    try {
      await _cameraService.initialize();
      _cameraService.startPreview();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Failed to initialize camera: $e');
    }

    try {
      await _audioService.initialize();
      setState(() {
        _isAudioInitialized = true;
      });
    } catch (e) {
      print('Failed to initialize audio: $e');
    }
  }

  // Toggle camera recording
  Future<void> _toggleCameraRecording() async {
    try {
      if (_cameraService.isRecording) {
        await _cameraService.stopRecording();
      } else {
        await _cameraService.startRecording();
      }
      setState(() {});
    } catch (e) {
      print('Failed to toggle camera recording: $e');
    }
  }

  // Toggle audio recording
  Future<void> _toggleAudioRecording() async {
    try {
      if (_audioService.isRecording) {
        await _audioService.stopRecording();
      } else {
        await _audioService.startRecording();
      }
      setState(() {});
    } catch (e) {
      print('Failed to toggle audio recording: $e');
    }
  }

  // Capture photo
  Future<void> _capturePhoto() async {
    try {
      await _cameraService.capturePhoto();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('照片已拍摄'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      print('Failed to capture photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备控制中心')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 设备选择
            _buildDeviceSelector(context),
            const SizedBox(height: 20),

            // 摄像头预览
            _isCameraInitialized
                ? _buildCameraPreview(context)
                : _buildLoadingPlaceholder('摄像头初始化中...'),
            const SizedBox(height: 20),

            // 摄像头控制
            _buildCameraControls(context),
            const SizedBox(height: 20),

            // 音频控制
            _buildAudioControls(context),
          ],
        ),
      ),
    );
  }

  // 设备选择器
  Widget _buildDeviceSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择设备',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedDevice,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: '摄像头 1', child: Text('摄像头 1')),
                DropdownMenuItem(value: '摄像头 2', child: Text('摄像头 2')),
                DropdownMenuItem(value: '摄像头 3', child: Text('摄像头 3')),
                DropdownMenuItem(value: '麦克风 1', child: Text('麦克风 1')),
                DropdownMenuItem(value: '麦克风 2', child: Text('麦克风 2')),
                DropdownMenuItem(value: '扬声器 1', child: Text('扬声器 1')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDevice = value!;
                });
              },
              style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  // 摄像头预览
  Widget _buildCameraPreview(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            CameraPreview(_cameraService.controller!),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedDevice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 加载占位符
  Widget _buildLoadingPlaceholder(String text) {
    return Card(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 摄像头控制
  Widget _buildCameraControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '摄像头控制',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 控制按钮网格
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildControlButton(
                  context,
                  icon: Icons.camera_alt_outlined,
                  title: '拍照',
                  onPressed: _capturePhoto,
                ),
                _buildControlButton(
                  context,
                  icon: _cameraService.isRecording
                      ? Icons.stop
                      : Icons.videocam_outlined,
                  title: _cameraService.isRecording ? '停止录制' : '开始录制',
                  onPressed: _toggleCameraRecording,
                  color: _cameraService.isRecording
                      ? AppTheme.errorColor
                      : AppTheme.primaryColor,
                ),
                _buildControlButton(
                  context,
                  icon: Icons.flip_camera_android_outlined,
                  title: '切换摄像头',
                  onPressed: () async {
                    await _cameraService.switchCamera();
                    setState(() {});
                  },
                ),
                _buildControlButton(
                  context,
                  icon: Icons.flash_off_outlined,
                  title: '闪光灯',
                  onPressed: () async {
                    await _cameraService.toggleFlash();
                    setState(() {});
                  },
                ),
                _buildControlButton(
                  context,
                  icon: Icons.zoom_in_outlined,
                  title: '缩放',
                  onPressed: () {},
                ),
                _buildControlButton(
                  context,
                  icon: Icons.settings_outlined,
                  title: '设置',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 音频控制
  Widget _buildAudioControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '音频控制',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 录音控制
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _audioService.isRecording ? '录音中...' : '麦克风',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _toggleAudioRecording,
                  icon: Icon(
                    _audioService.isRecording ? Icons.stop : Icons.mic_outlined,
                  ),
                  label: Text(_audioService.isRecording ? '停止录音' : '开始录音'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _audioService.isRecording
                        ? AppTheme.errorColor
                        : AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 音量控制
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '扬声器音量',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_down_outlined),
                      onPressed: () {
                        setState(() {
                          _volume = (_volume - 0.1).clamp(0.0, 1.0);
                          _audioService.setVolume(_volume);
                        });
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                            _audioService.setVolume(_volume);
                          });
                        },
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppTheme.primaryColor,
                        inactiveColor: AppTheme.borderColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_outlined),
                      onPressed: () {
                        setState(() {
                          _volume = (_volume + 0.1).clamp(0.0, 1.0);
                          _audioService.setVolume(_volume);
                        });
                      },
                    ),
                    Text(
                      '${(_volume * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 控制按钮
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    Color color = AppTheme.primaryColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
