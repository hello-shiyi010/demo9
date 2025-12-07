
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isInitialized = false;
  String? _recordingPath;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  String? get recordingPath => _recordingPath;

  // Initialize the audio service
  Future<void> initialize() async {
    // Request microphone permission
    if (await Permission.microphone.request().isDenied) {
      throw Exception('Microphone permission denied');
    }

    // Request storage permission (for saving recordings)
    if (await Permission.storage.request().isDenied) {
      throw Exception('Storage permission denied');
    }

    // Initialize recorder
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 100));

    // Initialize player
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();

    _isInitialized = true;
  }

  // Start recording
  Future<void> startRecording() async {
    if (_recorder == null || !_isInitialized || _isRecording) return;

    try {
      _recordingPath = 'audio_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacMP4,
      );
      _isRecording = true;
    } catch (e) {
      print('Failed to start recording: $e');
      throw e;
    }
  }

  // Stop recording
  Future<String?> stopRecording() async {
    if (_recorder == null || !_isRecording) return null;

    try {
      await _recorder!.stopRecorder();
      _isRecording = false;
      return _recordingPath;
    } catch (e) {
      print('Failed to stop recording: $e');
      throw e;
    }
  }

  // Start playing
  Future<void> startPlaying(String path) async {
    if (_player == null || !_isInitialized || _isPlaying) return;

    try {
      await _player!.startPlayer(fromURI: path, codec: Codec.aacMP4);
      _isPlaying = true;
    } catch (e) {
      print('Failed to start playing: $e');
      throw e;
    }
  }

  // Stop playing
  Future<void> stopPlaying() async {
    if (_player == null || !_isPlaying) return;

    try {
      await _player!.stopPlayer();
      _isPlaying = false;
    } catch (e) {
      print('Failed to stop playing: $e');
      throw e;
    }
  }

  // Set speaker volume
  Future<void> setVolume(double volume) async {
    if (_player == null || !_isInitialized) return;
    
    try {
      await _player!.setVolume(volume);
    } catch (e) {
      print('Failed to set volume: $e');
      throw e;
    }
  }

  // Get recording amplitude
  Stream<RecordingDisposition>? getRecordingAmplitude() {
    if (_recorder == null || !_isInitialized) return null;
    return _recorder!.onProgress;
  }

  // Dispose the audio service
  Future<void> dispose() async {
    if (_isRecording) {
      await stopRecording();
    }
    if (_isPlaying) {
      await stopPlaying();
    }
    await _recorder?.closeRecorder();
    await _player?.closePlayer();
    _isInitialized = false;
  }
}