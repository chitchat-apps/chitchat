import "package:chitchat/models/emotes/bttv_emote.dart";
import "package:chitchat/models/emotes/ffz_emote.dart";
import "package:chitchat/models/emotes/seven_tv_emote.dart";
import "package:chitchat/models/emotes/twitch_emote.dart";
import "package:json_annotation/json_annotation.dart";

part "emote.g.dart";

@JsonSerializable()
class Emote {
  final String name;
  final int? width;
  final int? height;
  final bool zeroWidth;
  final String url;
  final EmoteType type;
  final String? ownerId;

  const Emote({
    required this.name,
    this.width,
    this.height,
    required this.zeroWidth,
    required this.url,
    required this.type,
    this.ownerId,
  });

  factory Emote.fromTwitch(TwitchEmote emote, EmoteType type) {
    return Emote(
      name: emote.name,
      zeroWidth: false,
      url:
          "https://static-cdn.jtvnw.net/emoticons/v2/${emote.id}/default/dark/3.0",
      type: type,
      ownerId: emote.ownerId,
    );
  }

  factory Emote.fromFFZ(FFZEmote emote, EmoteType type) => Emote(
        name: emote.name,
        zeroWidth: false,
        width: emote.width,
        height: emote.height,
        url: emote.urls.url4x ?? emote.urls.url2x ?? emote.urls.url1x,
        type: type,
      );

  factory Emote.fromBTTV(BTTVEmote emote, EmoteType type) => Emote(
        name: emote.code,
        // zeroWidth: zeroWidthEmotes.contains(emote.code),
        zeroWidth: false,
        url: "https://cdn.betterttv.net/emote/${emote.id}/3x",
        type: type,
      );

  factory Emote.fromSevenTv(SevenTvEmote emote, EmoteType type) => Emote(
        name: emote.name,
        width: emote.width.first,
        height: emote.height.first,
        zeroWidth: emote.visibilitySimple.contains("ZERO_WIDTH"),
        url: emote.urls[3][1],
        type: type,
      );

  factory Emote.fromJson(Map<String, dynamic> json) => _$EmoteFromJson(json);
}

enum EmoteType {
  twitchBits,
  twitchFollower,
  twitchSubscriber,
  twitchGlobal,
  twitchUnlocked,
  twitchChannel,
  ffzGlobal,
  ffzChannel,
  bttvGlobal,
  bttvChannel,
  bttvShared,
  sevenTvGlobal,
  sevenTvChannel,
}

String emoteType(EmoteType type) {
  return switch (type) {
    EmoteType.twitchBits => "Twitch Bits",
    EmoteType.twitchFollower => "Twitch Follower",
    EmoteType.twitchSubscriber => "Twitch Subscriber",
    EmoteType.twitchGlobal => "Twitch Global",
    EmoteType.twitchUnlocked => "Twitch Unlocked",
    EmoteType.twitchChannel => "Twitch Channel",
    EmoteType.ffzGlobal => "FFZ Global",
    EmoteType.ffzChannel => "FFZ Channel",
    EmoteType.bttvGlobal => "BTTV Global",
    EmoteType.bttvChannel => "BTTV Channel",
    EmoteType.bttvShared => "BTTV Shared",
    EmoteType.sevenTvGlobal => "7TV Global",
    EmoteType.sevenTvChannel => "7TV Channel",
  };
}
