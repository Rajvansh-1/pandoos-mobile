import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_handler.dart';
import 'stream_resolver.dart';

final audioHandlerProvider = Provider<PandoosAudioHandler>((ref) {
  final streamResolver = ref.watch(streamResolverProvider);
  return PandoosAudioHandler(streamResolver);
});
