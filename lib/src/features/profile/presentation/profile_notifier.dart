import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, bool>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<bool> {
  ProfileNotifier() : super(false);
}
