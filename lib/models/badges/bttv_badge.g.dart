// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bttv_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BTTVBadge _$BTTVBadgeFromJson(Map<String, dynamic> json) => BTTVBadge(
      providerId: json['providerId'] as String,
      badge: BTTVBadgeDetails.fromJson(json['badge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BTTVBadgeToJson(BTTVBadge instance) => <String, dynamic>{
      'providerId': instance.providerId,
      'badge': instance.badge,
    };

BTTVBadgeDetails _$BTTVBadgeDetailsFromJson(Map<String, dynamic> json) =>
    BTTVBadgeDetails(
      description: json['description'] as String,
      svg: json['svg'] as String,
    );

Map<String, dynamic> _$BTTVBadgeDetailsToJson(BTTVBadgeDetails instance) =>
    <String, dynamic>{
      'description': instance.description,
      'svg': instance.svg,
    };
