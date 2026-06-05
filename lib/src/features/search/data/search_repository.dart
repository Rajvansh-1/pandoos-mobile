import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'innertube_data_source.dart';
import '../../../core/models/track.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(innertubeDataSourceProvider));
});

class SearchRepository {
  final InnertubeDataSource _dataSource;

  SearchRepository(this._dataSource);

  Future<List<Track>> searchTracks(String query) async {
    return _dataSource.searchTracks(query);
  }
}
