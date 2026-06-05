// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pandoos_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PandoosUser _$PandoosUserFromJson(Map<String, dynamic> json) {
  return _PandoosUser.fromJson(json);
}

/// @nodoc
mixin _$PandoosUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PandoosUserCopyWith<PandoosUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandoosUserCopyWith<$Res> {
  factory $PandoosUserCopyWith(
          PandoosUser value, $Res Function(PandoosUser) then) =
      _$PandoosUserCopyWithImpl<$Res, PandoosUser>;
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String? avatarUrl,
      String createdAt});
}

/// @nodoc
class _$PandoosUserCopyWithImpl<$Res, $Val extends PandoosUser>
    implements $PandoosUserCopyWith<$Res> {
  _$PandoosUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PandoosUserImplCopyWith<$Res>
    implements $PandoosUserCopyWith<$Res> {
  factory _$$PandoosUserImplCopyWith(
          _$PandoosUserImpl value, $Res Function(_$PandoosUserImpl) then) =
      __$$PandoosUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String? avatarUrl,
      String createdAt});
}

/// @nodoc
class __$$PandoosUserImplCopyWithImpl<$Res>
    extends _$PandoosUserCopyWithImpl<$Res, _$PandoosUserImpl>
    implements _$$PandoosUserImplCopyWith<$Res> {
  __$$PandoosUserImplCopyWithImpl(
      _$PandoosUserImpl _value, $Res Function(_$PandoosUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PandoosUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PandoosUserImpl implements _PandoosUser {
  const _$PandoosUserImpl(
      {required this.id,
      required this.email,
      required this.username,
      this.avatarUrl,
      required this.createdAt});

  factory _$PandoosUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$PandoosUserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? avatarUrl;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'PandoosUser(id: $id, email: $email, username: $username, avatarUrl: $avatarUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PandoosUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, username, avatarUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PandoosUserImplCopyWith<_$PandoosUserImpl> get copyWith =>
      __$$PandoosUserImplCopyWithImpl<_$PandoosUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PandoosUserImplToJson(
      this,
    );
  }
}

abstract class _PandoosUser implements PandoosUser {
  const factory _PandoosUser(
      {required final String id,
      required final String email,
      required final String username,
      final String? avatarUrl,
      required final String createdAt}) = _$PandoosUserImpl;

  factory _PandoosUser.fromJson(Map<String, dynamic> json) =
      _$PandoosUserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  String? get avatarUrl;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PandoosUserImplCopyWith<_$PandoosUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
