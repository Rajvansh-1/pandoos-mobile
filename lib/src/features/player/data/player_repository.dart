import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepository();
});

class PlayerRepository {
  // Stub for local player history or queue storage if needed
  Future<void> saveQueue(List<String> trackIds) async {}
  Future<List<String>> getQueue() async { return []; }
}
