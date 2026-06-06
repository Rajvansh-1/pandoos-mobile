import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics_line.freezed.dart';

@freezed
class LyricsLine with _$LyricsLine {
  const factory LyricsLine({
    required Duration time,
    required String words,
  }) = _LyricsLine;
}
