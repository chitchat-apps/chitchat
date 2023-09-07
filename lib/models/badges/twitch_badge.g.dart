// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchBadge _$TwitchBadgeFromJson(Map<String, dynamic> json) => TwitchBadge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url1x: json['image_url_1x'] as String,
      url2x: json['image_url_2x'] as String,
      url4x: json['image_url_4x'] as String,
    );

Map<String, dynamic> _$TwitchBadgeToJson(TwitchBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image_url_1x': instance.url1x,
      'image_url_2x': instance.url2x,
      'image_url_4x': instance.url4x,
    };
