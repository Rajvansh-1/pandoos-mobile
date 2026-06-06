import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/models/track.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Track> tracks,
  }) = _HomeState;
}
