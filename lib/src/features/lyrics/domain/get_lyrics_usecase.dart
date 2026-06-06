import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/lrclib_data_source.dart';
import '../domain/lyrics_line.dart';
import '../../../core/models/track.dart';

final getLyricsUseCaseProvider = Provider<GetLyricsUseCase>((ref) {
  return GetLyricsUseCase(ref.watch(lrclibDataSourceProvider));
});

class GetLyricsUseCase {
  final LrcLibDataSource _dataSource;

  GetLyricsUseCase(this._dataSource);

  Future<List<LyricsLine>> call(Track track) async {
    return _dataSource.getSyncedLyrics(track.title, track.artist, track.duration);
  }
}
