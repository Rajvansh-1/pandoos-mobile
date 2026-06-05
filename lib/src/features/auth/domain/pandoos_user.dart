import 'package:freezed_annotation/freezed_annotation.dart';

part 'pandoos_user.freezed.dart';
part 'pandoos_user.g.dart';

@freezed
class PandoosUser with _$PandoosUser {
  const factory PandoosUser({
    required String id,
    required String email,
    required String username,
    String? avatarUrl,
    required String createdAt,
  }) = _PandoosUser;

  factory PandoosUser.fromJson(Map<String, dynamic> json) => _$PandoosUserFromJson(json);
}
