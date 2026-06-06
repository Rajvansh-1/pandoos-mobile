import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../domain/lyrics_line.dart';
import '../../../core/errors/pandoos_exception.dart';

final lrclibDataSourceProvider = Provider<LrcLibDataSource>((ref) {
  return LrcLibDataSource(Dio());
});

class LrcLibDataSource {
  final Dio _dio;

  LrcLibDataSource(this._dio);

  Future<List<LyricsLine>> getSyncedLyrics(String trackName, String artistName, int duration) async {
    try {
      final response = await _dio.get(
        'https://lrclib.net/api/get',
        queryParameters: {
          'track_name': trackName,
          'artist_name': artistName,
          'duration': duration.toString(),
        },
      );

      final data = response.data;
      final syncedLyrics = data['syncedLyrics'] as String?;

      if (syncedLyrics == null || syncedLyrics.isEmpty) {
        return [];
      }

      return _parseLrc(syncedLyrics);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return []; // Not found is fine, just empty lyrics
      }
      throw PandoosException('Failed to fetch lyrics from LRCLIB: $e');
    }
  }

  List<LyricsLine> _parseLrc(String lrc) {
    final lines = lrc.split('\n');
    final result = <LyricsLine>[];
    
    final regex = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)');

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        final millis = int.parse(match.group(3)!.padRight(3, '0'));
        final text = match.group(4)!.trim();
        
        final duration = Duration(
          minutes: minutes,
          seconds: seconds,
          milliseconds: millis,
        );
        
        result.add(LyricsLine(time: duration, words: text));
      }
    }
    
    return result;
  }
}
