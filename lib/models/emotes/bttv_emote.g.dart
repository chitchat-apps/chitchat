// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bttv_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BTTVChannelEmote _$BTTVChannelEmoteFromJson(Map<String, dynamic> json) =>
    BTTVChannelEmote(
      (json['channelEmotes'] as List<dynamic>)
          .map((e) => BTTVEmote.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['sharedEmotes'] as List<dynamic>)
          .map((e) => BTTVEmote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BTTVChannelEmoteToJson(BTTVChannelEmote instance) =>
    <String, dynamic>{
      'channelEmotes': instance.channelEmotes,
      'sharedEmotes': instance.sharedEmotes,
    };

BTTVEmote _$BTTVEmoteFromJson(Map<String, dynamic> json) => BTTVEmote(
      json['id'] as String,
      json['code'] as String,
    );

Map<String, dynamic> _$BTTVEmoteToJson(BTTVEmote instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
    };
