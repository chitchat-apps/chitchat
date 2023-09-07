// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emote _$EmoteFromJson(Map<String, dynamic> json) => Emote(
      name: json['name'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      zeroWidth: json['zeroWidth'] as bool,
      url: json['url'] as String,
      type: $enumDecode(_$EmoteTypeEnumMap, json['type']),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$EmoteToJson(Emote instance) => <String, dynamic>{
      'name': instance.name,
      'width': instance.width,
      'height': instance.height,
      'zeroWidth': instance.zeroWidth,
      'url': instance.url,
      'type': _$EmoteTypeEnumMap[instance.type]!,
      'ownerId': instance.ownerId,
    };

const _$EmoteTypeEnumMap = {
  EmoteType.twitchBits: 'twitchBits',
  EmoteType.twitchFollower: 'twitchFollower',
  EmoteType.twitchSubscriber: 'twitchSubscriber',
  EmoteType.twitchGlobal: 'twitchGlobal',
  EmoteType.twitchUnlocked: 'twitchUnlocked',
  EmoteType.twitchChannel: 'twitchChannel',
  EmoteType.ffzGlobal: 'ffzGlobal',
  EmoteType.ffzChannel: 'ffzChannel',
  EmoteType.bttvGlobal: 'bttvGlobal',
  EmoteType.bttvChannel: 'bttvChannel',
  EmoteType.bttvShared: 'bttvShared',
  EmoteType.sevenTvGlobal: 'sevenTvGlobal',
  EmoteType.sevenTvChannel: 'sevenTvChannel',
};
