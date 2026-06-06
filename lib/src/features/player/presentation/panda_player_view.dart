import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/panda/panda_controller.dart';
import '../../../core/panda/panda_state.dart';
import '../../../core/panda/fft_isolate.dart';
import '../../../core/panda/bpm_detector.dart';
import '../../../core/panda/panda_emotion_engine.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';

class PandaPlayerView extends ConsumerStatefulWidget {
  const PandaPlayerView({super.key});

  @override
  ConsumerState<PandaPlayerView> createState() => _PandaPlayerViewState();
}

class _PandaPlayerViewState extends ConsumerState<PandaPlayerView> {
  final PandaController _pandaController = PandaController();
  final BPMDetector _bpmDetector = BPMDetector();
  FFTIsolate? _fftIsolate;

  bool _isPlaying = false;
  PlaybackMood _currentPlaybackState = PlaybackMood.idle;

  @override
  void initState() {
    super.initState();
    _startAudioProcessing();
  }

  void _startAudioProcessing() {
    _fftIsolate = FFTIsolate(
      onAmplitudeUpdate: (amplitude) {
        if (!mounted || !_isPlaying) return;
        
        // 1. Update direct Rive amplitudes
        _pandaController.onAmplitudeUpdate(amplitude);
        
        // 2. Feed BPM detector if we hit a beat drop
        if (amplitude > 0.85) {
          _bpmDetector.registerBeat();
        }

        // 3. Infer total mood periodically and update Rive State
        final engine = ref.read(pandaEmotionEngineProvider);
        final inferredState = engine.inferCurrentState(
          playback: _currentPlaybackState,
          energyLevel: amplitude,
          bpm: _bpmDetector.currentBpm,
          amplitude: amplitude,
        );

        _pandaController.onMoodChange(inferredState.mood);
      },
    );
    _fftIsolate?.start();
  }

  @override
  void dispose() {
    _fftIsolate?.stop();
    _pandaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to playback state to animate panda & toggle FFT
    ref.listen(audioHandlerProvider, (previous, next) {
      if (next != null) {
        next.playbackState.listen((state) {
          if (!mounted) return;
          final isPlaying = state.playing;
          setState(() => _isPlaying = isPlaying);
          
          _currentPlaybackState = isPlaying ? PlaybackMood.playing : PlaybackMood.paused;
          _pandaController.onPlaybackStateChange(_currentPlaybackState);
        });
      }
    });

    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glassmorphic Pedestal for Panda
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.03),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: PandoosColors.primary.withValues(alpha: _isPlaying ? 0.3 : 0.1),
                  blurRadius: _isPlaying ? 80 : 40,
                  spreadRadius: _isPlaying ? 20 : 10,
                )
              ],
            ),
          ),
          
          // The actual Rive widget (stubbed with Image if riv fails)
          // In production, this uses RiveAnimation.asset('assets/rive/panda.riv')
          GestureDetector(
            onTap: () {
              // Manual interaction causes curious mood override
              _pandaController.onMoodChange(PandaMood.curious);
            },
            child: Image.asset(
              'assets/images/panda_placeholder.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
