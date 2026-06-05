import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import 'home_data_source.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(homeDataSourceProvider));
});

class HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepository(this._dataSource);

  Future<List<Track>> getTrendingFeed() async {
    return await _dataSource.getTrendingTracks();
  }
}
