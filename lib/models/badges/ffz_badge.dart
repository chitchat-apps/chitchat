import "package:json_annotation/json_annotation.dart";

part "ffz_badge.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class FFZBadge {
  final int id;
  final String title;
  final String color;
  final FFZBadgeUrls urls;

  FFZBadge({
    required this.id,
    required this.title,
    required this.color,
    required this.urls,
  });

  factory FFZBadge.fromJson(Map<String, dynamic> json) =>
      _$FFZBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$FFZBadgeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FFZBadgeUrls {
  @JsonKey(name: "1")
  final String url1x;
  @JsonKey(name: "2")
  final String url2x;
  @JsonKey(name: "4")
  final String url4x;

  FFZBadgeUrls({
    required this.url1x,
    required this.url2x,
    required this.url4x,
  });

  factory FFZBadgeUrls.fromJson(Map<String, dynamic> json) =>
      _$FFZBadgeUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$FFZBadgeUrlsToJson(this);
}
