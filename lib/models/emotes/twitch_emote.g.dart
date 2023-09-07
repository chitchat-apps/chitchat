// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchEmote _$TwitchEmoteFromJson(Map<String, dynamic> json) => TwitchEmote(
      id: json['id'] as String,
      name: json['name'] as String,
      emoteType: json['emote_type'] as String?,
      ownerId: json['owner_id'] as String?,
    );

Map<String, dynamic> _$TwitchEmoteToJson(TwitchEmote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emote_type': instance.emoteType,
      'owner_id': instance.ownerId,
    };
