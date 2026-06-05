import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import 'stream_resolver.dart';

class PandoosAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final StreamResolver _streamResolver;
  final AudioPlayer _player = AudioPlayer();
  // ignore: deprecated_member_use
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  PandoosAudioHandler(this._streamResolver) {
    _init();
  }

  Future<void> _init() async {
    // Connect just_audio to audio_service
    _player.playbackEventStream.listen(_broadcastState);
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      debugPrint("Error setting audio source: $e");
    }
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  Future<void> playTrack(Track track) async {
    final streamUrl = await _streamResolver.resolveStreamUrl(track);
    final finalTrack = streamUrl != null ? track.copyWith(streamUrl: streamUrl) : track;

    final item = MediaItem(
      id: finalTrack.id,
      title: finalTrack.title,
      artist: finalTrack.artist,
      artUri: Uri.parse(finalTrack.albumArt),
      duration: Duration(seconds: finalTrack.duration),
      extras: {'streamUrl': finalTrack.streamUrl},
    );
    
    mediaItem.add(item);
    
    if (finalTrack.streamUrl != null) {
      await _player.setUrl(finalTrack.streamUrl!);
      play();
    } else {
      debugPrint("Could not resolve stream URL for track: ${track.title}");
    }
  }

  Future<void> playFromQueue(int index) async {
    await _player.seek(Duration.zero, index: index);
    play();
  }

  Future<void> addToQueue(Track track) async {
    final item = MediaItem(
      id: track.id,
      title: track.title,
      artist: track.artist,
      artUri: Uri.parse(track.albumArt),
      duration: Duration(seconds: track.duration),
    );
    final queueList = queue.value.toList();
    queueList.add(item);
    queue.add(queueList);
    // Add to concatenating audio source
    if (track.streamUrl != null) {
      _playlist.add(AudioSource.uri(Uri.parse(track.streamUrl!)));
    }
  }

  Future<void> removeFromQueue(int index) async {
    final queueList = queue.value.toList();
    queueList.removeAt(index);
    queue.add(queueList);
    _playlist.removeAt(index);
  }

  Future<void> clearQueue() async {
    queue.add([]);
    await _playlist.clear();
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    final queueList = queue.value.toList();
    final item = queueList.removeAt(oldIndex);
    queueList.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    queue.add(queueList);
    await _playlist.move(oldIndex, newIndex > oldIndex ? newIndex - 1 : newIndex);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    final mode = const {
      AudioServiceRepeatMode.none: LoopMode.off,
      AudioServiceRepeatMode.one: LoopMode.one,
      AudioServiceRepeatMode.all: LoopMode.all,
      AudioServiceRepeatMode.group: LoopMode.all,
    }[repeatMode]!;
    await _player.setLoopMode(mode);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    if (enabled) {
      await _player.shuffle();
    }
    await _player.setShuffleModeEnabled(enabled);
  }
}
