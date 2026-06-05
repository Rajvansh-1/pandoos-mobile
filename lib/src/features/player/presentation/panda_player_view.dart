import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import '../../../core/panda/panda_controller.dart';
import '../../../core/panda/panda_state.dart';
import '../../../core/audio/audio_service_provider.dart';

class PandaPlayerView extends ConsumerStatefulWidget {
  const PandaPlayerView({Key? key}) : super(key: key);

  @override
  ConsumerState<PandaPlayerView> createState() => _PandaPlayerViewState();
}

class _PandaPlayerViewState extends ConsumerState<PandaPlayerView> {
  final PandaController _pandaController = PandaController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pandaController.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    _pandaController.init(artboard);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to playback state to animate panda
    ref.listen(audioHandlerProvider, (previous, next) {
      if (next != null) {
        next.playbackState.listen((state) {
          if (state.playing) {
            _pandaController.onPlaybackStateChange(PlaybackMood.playing);
          } else {
            _pandaController.onPlaybackStateChange(PlaybackMood.paused);
          }
        });
      }
    });

    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fallback background / shadow
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 50,
                  spreadRadius: 20,
                )
              ],
            ),
          ),
          
          // Rive Animation
          RiveAnimation.asset(
            'assets/rive/panda.riv',
            fit: BoxFit.contain,
            onInit: _onRiveInit,
            // If the Rive file is missing or broken, RiveAnimation shows an empty box or error
          ),
        ],
      ),
    );
  }
}
