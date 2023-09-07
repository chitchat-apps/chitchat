import "package:json_annotation/json_annotation.dart";

part "twitch_badge.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchBadge {
  final String id;
  final String title;
  final String description;

  @JsonKey(name: "image_url_1x")
  final String url1x;
  @JsonKey(name: "image_url_2x")
  final String url2x;
  @JsonKey(name: "image_url_4x")
  final String url4x;

  TwitchBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.url1x,
    required this.url2x,
    required this.url4x,
  });

  factory TwitchBadge.fromJson(Map<String, dynamic> json) =>
      _$TwitchBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$TwitchBadgeToJson(this);
}
