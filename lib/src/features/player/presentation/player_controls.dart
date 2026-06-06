import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/widgets/glass_card.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<bool>(
      stream: audioHandler.playbackState.map((state) => state.playing),
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        return GlassCard(
          borderRadius: 40,
          blur: 20,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle_rounded, color: Colors.white54, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                onPressed: audioHandler.skipToPrevious,
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: PandoosColors.primary,
                  boxShadow: [
                    BoxShadow(color: PandoosColors.primary, blurRadius: 20, spreadRadius: 2)
                  ]
                ),
                child: IconButton(
                  icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 48),
                  onPressed: () {
                    if (playing) {
                      audioHandler.pause();
                    } else {
                      audioHandler.play();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                onPressed: audioHandler.skipToNext,
              ),
              IconButton(
                icon: const Icon(Icons.repeat_rounded, color: Colors.white54, size: 28),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
