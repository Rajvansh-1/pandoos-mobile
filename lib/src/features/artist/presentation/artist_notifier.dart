import 'package:flutter_riverpod/flutter_riverpod.dart';

final artistNotifierProvider = StateNotifierProvider<ArtistNotifier, bool>((ref) {
  return ArtistNotifier();
});

class ArtistNotifier extends StateNotifier<bool> {
  ArtistNotifier() : super(false);
}
