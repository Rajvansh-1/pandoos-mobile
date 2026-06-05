// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pandoos_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PandoosUserImpl _$$PandoosUserImplFromJson(Map<String, dynamic> json) =>
    _$PandoosUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$PandoosUserImplToJson(_$PandoosUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt,
    };
