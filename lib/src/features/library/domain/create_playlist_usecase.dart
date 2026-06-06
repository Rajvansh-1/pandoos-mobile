import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/pandoos_exception.dart';

final createPlaylistUseCaseProvider = Provider<CreatePlaylistUseCase>((ref) {
  return CreatePlaylistUseCase();
});

class CreatePlaylistUseCase {
  Future<String> call(String name, {String? description}) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw PandoosException('User not authenticated');

    final response = await client.from('playlists').insert({
      'user_id': userId,
      'name': name,
      'description': description ?? '',
      'is_public': false,
      'track_count': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).select('id').single();

    return response['id'] as String;
  }
}
