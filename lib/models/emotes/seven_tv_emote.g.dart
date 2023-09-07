// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seven_tv_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTvEmote _$SevenTvEmoteFromJson(Map<String, dynamic> json) => SevenTvEmote(
      json['name'] as String,
      (json['visibility_simple'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['width'] as List<dynamic>).map((e) => e as int).toList(),
      (json['height'] as List<dynamic>).map((e) => e as int).toList(),
      (json['urls'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$SevenTvEmoteToJson(SevenTvEmote instance) =>
    <String, dynamic>{
      'name': instance.name,
      'visibility_simple': instance.visibilitySimple,
      'width': instance.width,
      'height': instance.height,
      'urls': instance.urls,
    };
