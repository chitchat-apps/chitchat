// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ffz_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FFZBadge _$FFZBadgeFromJson(Map<String, dynamic> json) => FFZBadge(
      id: json['id'] as int,
      title: json['title'] as String,
      color: json['color'] as String,
      urls: FFZBadgeUrls.fromJson(json['urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FFZBadgeToJson(FFZBadge instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'urls': instance.urls,
    };

FFZBadgeUrls _$FFZBadgeUrlsFromJson(Map<String, dynamic> json) => FFZBadgeUrls(
      url1x: json['1'] as String,
      url2x: json['2'] as String,
      url4x: json['4'] as String,
    );

Map<String, dynamic> _$FFZBadgeUrlsToJson(FFZBadgeUrls instance) =>
    <String, dynamic>{
      '1': instance.url1x,
      '2': instance.url2x,
      '4': instance.url4x,
    };
