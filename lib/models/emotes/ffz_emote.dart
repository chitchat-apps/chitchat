import "package:json_annotation/json_annotation.dart";

part "ffz_emote.g.dart";

@JsonSerializable()
class FFZImages {
  @JsonKey(name: "1")
  final String url1x;
  @JsonKey(name: "2")
  final String? url2x;
  @JsonKey(name: "4")
  final String? url4x;

  const FFZImages(
    this.url1x,
    this.url2x,
    this.url4x,
  );

  factory FFZImages.fromJson(Map<String, dynamic> json) =>
      _$FFZImagesFromJson(json);
}

@JsonSerializable()
class FFZEmote {
  final String name;
  final int height;
  final int width;
  final FFZImages urls;

  const FFZEmote(
    this.name,
    this.height,
    this.width,
    this.urls,
  );

  factory FFZEmote.fromJson(Map<String, dynamic> json) =>
      _$FFZEmoteFromJson(json);
}
