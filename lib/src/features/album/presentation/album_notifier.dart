import 'package:flutter_riverpod/flutter_riverpod.dart';

final albumNotifierProvider = StateNotifierProvider<AlbumNotifier, bool>((ref) {
  return AlbumNotifier();
});

class AlbumNotifier extends StateNotifier<bool> {
  AlbumNotifier() : super(false);
}
