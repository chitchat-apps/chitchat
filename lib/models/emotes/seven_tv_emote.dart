import "package:json_annotation/json_annotation.dart";

part "seven_tv_emote.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class SevenTvEmote {
  final String name;
  final List<String> visibilitySimple;
  final List<int> width;
  final List<int> height;
  final List<List<String>> urls;

  const SevenTvEmote(
    this.name,
    this.visibilitySimple,
    this.width,
    this.height,
    this.urls,
  );

  factory SevenTvEmote.fromJson(Map<String, dynamic> json) =>
      _$SevenTvEmoteFromJson(json);
}
