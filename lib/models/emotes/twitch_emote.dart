import "package:json_annotation/json_annotation.dart";

part "twitch_emote.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchEmote {
  final String id;
  final String name;
  final String? emoteType;
  final String? ownerId;

  const TwitchEmote({
    required this.id,
    required this.name,
    this.emoteType,
    this.ownerId,
  });

  factory TwitchEmote.fromJson(Map<String, dynamic> json) =>
      _$TwitchEmoteFromJson(json);
}
