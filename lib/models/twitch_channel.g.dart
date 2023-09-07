// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchChannel _$TwitchChannelFromJson(Map<String, dynamic> json) =>
    TwitchChannel(
      broadcasterId: json['broadcaster_id'] as String,
      broadcasterLogin: json['broadcaster_login'] as String,
      broadcasterName: json['broadcaster_name'] as String,
      broadcasterLanguage: json['broadcaster_language'] as String,
      gameId: json['game_id'] as int,
      gameName: json['game_name'] as String,
      title: json['title'] as String,
      delay: json['delay'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      contentClassificationLabels:
          (json['content_classification_labels'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      isBrandedContent: json['is_branded_content'] as bool,
    );

Map<String, dynamic> _$TwitchChannelToJson(TwitchChannel instance) =>
    <String, dynamic>{
      'broadcaster_id': instance.broadcasterId,
      'broadcaster_login': instance.broadcasterLogin,
      'broadcaster_name': instance.broadcasterName,
      'broadcaster_language': instance.broadcasterLanguage,
      'game_id': instance.gameId,
      'game_name': instance.gameName,
      'title': instance.title,
      'delay': instance.delay,
      'tags': instance.tags,
      'content_classification_labels': instance.contentClassificationLabels,
      'is_branded_content': instance.isBrandedContent,
    };
