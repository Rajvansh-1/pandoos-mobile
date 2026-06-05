import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../data/home_repository.dart';

final getHomeFeedUseCaseProvider = Provider<GetHomeFeedUseCase>((ref) {
  return GetHomeFeedUseCase(ref.watch(homeRepositoryProvider));
});

class GetHomeFeedUseCase {
  final HomeRepository _repository;

  GetHomeFeedUseCase(this._repository);

  Future<List<Track>> execute() async {
    return await _repository.getTrendingFeed();
  }
}
