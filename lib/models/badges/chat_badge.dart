import "package:chitchat/models/badges/bttv_badge.dart";
import "package:chitchat/models/badges/ffz_badge.dart";
import "package:chitchat/models/badges/seven_tv_badge.dart";
import "package:chitchat/models/badges/twitch_badge.dart";

class ChatBadge {
  final String name;
  final String url;
  final BadgeType type;
  final String? color;

  ChatBadge({
    required this.name,
    required this.url,
    required this.type,
    this.color,
  });

  factory ChatBadge.fromTwitch(TwitchBadge badge) => ChatBadge(
        name: badge.title,
        url: badge.url4x,
        type: BadgeType.twitch,
      );

  factory ChatBadge.fromBTTV(BTTVBadge badge) => ChatBadge(
        name: badge.badge.description,
        url: badge.badge.svg,
        type: BadgeType.bttv,
      );

  factory ChatBadge.fromFFZ(FFZBadge badge) => ChatBadge(
        name: badge.title,
        url: badge.urls.url4x,
        color: badge.color,
        type: BadgeType.ffz,
      );

  factory ChatBadge.from7TV(SevenTvBadge badge) => ChatBadge(
        name: badge.tooltip,
        url: badge.urls[2][1],
        type: BadgeType.sevenTv,
      );
}

enum BadgeType {
  twitch,
  bttv,
  ffz,
  sevenTv,
}
