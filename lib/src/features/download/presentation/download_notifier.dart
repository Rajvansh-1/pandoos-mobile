import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloadNotifierProvider = StateNotifierProvider<DownloadNotifier, bool>((ref) {
  return DownloadNotifier();
});

class DownloadNotifier extends StateNotifier<bool> {
  DownloadNotifier() : super(false);
}
