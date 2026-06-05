import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';

class FftIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  final _amplitudeController = StreamController<double>.broadcast();
  final _bpmController = StreamController<double>.broadcast();

  Stream<double> get amplitudeStream => _amplitudeController.stream;
  Stream<double> get bpmStream => _bpmController.stream;

  bool _isRunning = false;

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_fftEntryPoint, _receivePort!.sendPort);

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is Map<String, dynamic>) {
        if (message.containsKey('amplitude')) {
          _amplitudeController.add(message['amplitude'] as double);
        }
        if (message.containsKey('bpm')) {
          _bpmController.add(message['bpm'] as double);
        }
      }
    });
  }

  void stop() {
    _isRunning = false;
    _sendPort?.send('stop');
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  void dispose() {
    stop();
    _amplitudeController.close();
    _bpmController.close();
  }

  // Temporary function to feed raw data (if available)
  void feedRawPcm(List<int> pcmData) {
    if (_sendPort != null && _isRunning) {
      _sendPort!.send({'pcm': pcmData});
    }
  }
}

// Top-level entry point for the isolate
void _fftEntryPoint(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  // For now, simulate real-time FFT amplitude (since raw PCM hook is complex)
  // In a full native implementation, this receives PCM chunks and runs FFT.
  Timer? mockTimer;
  final random = Random();
  double currentAmplitude = 0.0;
  
  mockTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
    // 60fps simulation
    currentAmplitude = (currentAmplitude * 0.8) + (random.nextDouble() * 0.2);
    sendPort.send({'amplitude': currentAmplitude});
  });

  receivePort.listen((message) {
    if (message == 'stop') {
      mockTimer?.cancel();
      receivePort.close();
    } else if (message is Map<String, dynamic> && message.containsKey('pcm')) {
      // Process real PCM data here
    }
  });
}
