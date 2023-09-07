// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchUser _$TwitchUserFromJson(Map<String, dynamic> json) => TwitchUser(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['display_name'] as String,
      profileImageUrl: json['profile_image_url'] as String,
      broadcasterType: json['broadcaster_type'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TwitchUserToJson(TwitchUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'display_name': instance.displayName,
      'broadcaster_type': instance.broadcasterType,
      'description': instance.description,
      'profile_image_url': instance.profileImageUrl,
    };
