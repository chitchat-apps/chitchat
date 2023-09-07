import "package:json_annotation/json_annotation.dart";

part "twitch_channel.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchChannel {
  final String broadcasterId;
  final String broadcasterLogin;
  final String broadcasterName;
  final String broadcasterLanguage;
  final int gameId;
  final String gameName;
  final String title;
  final int delay;
  final List<String> tags;
  final List<String> contentClassificationLabels;
  final bool isBrandedContent;

  const TwitchChannel({
    required this.broadcasterId,
    required this.broadcasterLogin,
    required this.broadcasterName,
    required this.broadcasterLanguage,
    required this.gameId,
    required this.gameName,
    required this.title,
    required this.delay,
    required this.tags,
    required this.contentClassificationLabels,
    required this.isBrandedContent,
  });

  factory TwitchChannel.fromJson(Map<String, dynamic> json) =>
      _$TwitchChannelFromJson(json);
}
