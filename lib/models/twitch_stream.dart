import "package:json_annotation/json_annotation.dart";

part "twitch_stream.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchStream {
  final String userId;
  final String userLogin;
  final String userName;
  final String gameId;
  final String gameName;
  final String title;
  final int viewerCount;
  final String startedAt;
  final String thumbnailUrl;

  const TwitchStream(
    this.userId,
    this.userLogin,
    this.userName,
    this.gameId,
    this.gameName,
    this.title,
    this.viewerCount,
    this.startedAt,
    this.thumbnailUrl,
  );

  factory TwitchStream.fromJson(Map<String, dynamic> json) =>
      _$TwitchStreamFromJson(json);

  Map<String, dynamic> toJson() => _$TwitchStreamToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchStreams {
  final List<TwitchStream> data;
  final Map<String, String> pagination;

  const TwitchStreams(
    this.data,
    this.pagination,
  );

  factory TwitchStreams.fromJson(Map<String, dynamic> json) =>
      _$TwitchStreamsFromJson(json);

  Map<String, dynamic> toJson() => _$TwitchStreamsToJson(this);
}
