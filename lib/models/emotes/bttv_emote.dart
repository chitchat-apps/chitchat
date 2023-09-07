import "package:json_annotation/json_annotation.dart";

part "bttv_emote.g.dart";

@JsonSerializable()
class BTTVChannelEmote {
  final List<BTTVEmote> channelEmotes;
  final List<BTTVEmote> sharedEmotes;

  const BTTVChannelEmote(
    this.channelEmotes,
    this.sharedEmotes,
  );

  factory BTTVChannelEmote.fromJson(Map<String, dynamic> json) =>
      _$BTTVChannelEmoteFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BTTVEmote {
  final String id;
  final String code;

  const BTTVEmote(
    this.id,
    this.code,
  );

  factory BTTVEmote.fromJson(Map<String, dynamic> json) =>
      _$BTTVEmoteFromJson(json);
}
