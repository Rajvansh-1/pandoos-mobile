import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/player_state.dart';

final playerNotifierProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier() : super(const PlayerState());
}
