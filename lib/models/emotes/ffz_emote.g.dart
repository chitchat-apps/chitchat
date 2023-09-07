// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ffz_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FFZImages _$FFZImagesFromJson(Map<String, dynamic> json) => FFZImages(
      json['1'] as String,
      json['2'] as String?,
      json['4'] as String?,
    );

Map<String, dynamic> _$FFZImagesToJson(FFZImages instance) => <String, dynamic>{
      '1': instance.url1x,
      '2': instance.url2x,
      '4': instance.url4x,
    };

FFZEmote _$FFZEmoteFromJson(Map<String, dynamic> json) => FFZEmote(
      json['name'] as String,
      json['height'] as int,
      json['width'] as int,
      FFZImages.fromJson(json['urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FFZEmoteToJson(FFZEmote instance) => <String, dynamic>{
      'name': instance.name,
      'height': instance.height,
      'width': instance.width,
      'urls': instance.urls,
    };
