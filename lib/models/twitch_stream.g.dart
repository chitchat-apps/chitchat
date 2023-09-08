// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchStream _$TwitchStreamFromJson(Map<String, dynamic> json) => TwitchStream(
      json['user_id'] as String,
      json['user_login'] as String,
      json['user_name'] as String,
      json['game_id'] as String,
      json['game_name'] as String,
      json['title'] as String,
      json['viewer_count'] as int,
      json['started_at'] as String,
      json['thumbnail_url'] as String,
    );

Map<String, dynamic> _$TwitchStreamToJson(TwitchStream instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_login': instance.userLogin,
      'user_name': instance.userName,
      'game_id': instance.gameId,
      'game_name': instance.gameName,
      'title': instance.title,
      'viewer_count': instance.viewerCount,
      'started_at': instance.startedAt,
      'thumbnail_url': instance.thumbnailUrl,
    };

TwitchStreams _$TwitchStreamsFromJson(Map<String, dynamic> json) =>
    TwitchStreams(
      (json['data'] as List<dynamic>)
          .map((e) => TwitchStream.fromJson(e as Map<String, dynamic>))
          .toList(),
      Map<String, String>.from(json['pagination'] as Map),
    );

Map<String, dynamic> _$TwitchStreamsToJson(TwitchStreams instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
    };
