import 'dart:isolate';
import 'dart:math';

/// A simplified FFT analyzer that runs in an isolate to prevent UI jank.
/// In a real production environment with native audio processing, this would 
/// bind to the raw PCM audio stream buffer.
class FFTIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  final Function(double amplitude) onAmplitudeUpdate;

  FFTIsolate({required this.onAmplitudeUpdate});

  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_fftProcessor, _receivePort!.sendPort);
    
    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is double) {
        onAmplitudeUpdate(message);
      }
    });
  }

  void stop() {
    _sendPort?.send('stop');
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  /// The entry point for the isolate
  static void _fftProcessor(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    bool running = true;
    receivePort.listen((message) {
      if (message == 'stop') {
        running = false;
        receivePort.close();
      }
    });

    final random = Random();
    
    // Simulate audio amplitude analysis buffer loop (approx 60fps)
    while (running) {
      // In production, this reads from an audio byte buffer and runs a Fast Fourier Transform.
      // Since we are not linking native C++ FFT libs in this step, we generate a smoothed
      // realistic amplitude curve that responds to "beats" organically.
      
      final isBeat = random.nextDouble() > 0.95;
      final baseAmplitude = 0.2 + (random.nextDouble() * 0.3); // Ambient noise floor 0.2 - 0.5
      
      final finalAmplitude = isBeat ? (0.8 + (random.nextDouble() * 0.2)) : baseAmplitude;
      
      sendPort.send(finalAmplitude);
      
      await Future.delayed(const Duration(milliseconds: 16)); // ~60fps
    }
  }
}
