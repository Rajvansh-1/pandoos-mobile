import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/models/track.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required List<Track> songs,
    required List<dynamic> artists, // stub
    required List<dynamic> albums,  // stub
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
