// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seven_tv_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTvBadge _$SevenTvBadgeFromJson(Map<String, dynamic> json) => SevenTvBadge(
      tooltip: json['tooltip'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SevenTvBadgeToJson(SevenTvBadge instance) =>
    <String, dynamic>{
      'tooltip': instance.tooltip,
      'urls': instance.urls,
      'users': instance.users,
    };
