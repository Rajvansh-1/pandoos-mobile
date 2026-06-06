import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/panda/panda_state.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(Hive.box('settings'));
});

class MoodRepository {
  final Box _box;

  MoodRepository(this._box);

  Future<void> saveManualMood(PandaMood mood) async {
    await _box.put('manual_mood', mood.index);
  }

  PandaMood? getManualMood() {
    final index = _box.get('manual_mood') as int?;
    if (index != null && index >= 0 && index < PandaMood.values.length) {
      return PandaMood.values[index];
    }
    return null;
  }

  Future<void> clearManualMood() async {
    await _box.delete('manual_mood');
  }
}
