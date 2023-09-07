class IrcMessageTags {
  final IrcBadgeInfo? badgeInfo;
  final IrcBadges? badges;
  final String? clientNonce;
  final String? color;
  final String? displayName;
  final String? emotes;
  final String? firstMsg;
  final String? flags;
  final String? id;
  final String? mod;
  final String? returningChatter;
  final String? roomId;
  final String? subscriber;
  final String? tmiSentTs;
  final String? turbo;
  final String? userId;
  final String? userType;

  IrcMessageTags({
    this.badgeInfo,
    this.badges,
    this.clientNonce,
    this.color,
    this.displayName,
    this.emotes,
    this.firstMsg,
    this.flags,
    this.id,
    this.mod,
    this.returningChatter,
    this.roomId,
    this.subscriber,
    this.tmiSentTs,
    this.turbo,
    this.userId,
    this.userType,
  });
}

class IrcBadgeInfo {
  final bool subscriber;
  final int months;

  IrcBadgeInfo({
    required this.subscriber,
    required this.months,
  });
}

class IrcBadges {
  // Booleans
  final bool broadcaster;
  final bool admin;
  final bool globalMod;
  final bool staff;
  final bool moderator;
  final bool partner;
  final bool vip;
  final bool founder;
  final bool premium;
  final bool turbo;

  // Numbers
  final int? bits;
  final int? bitsLeader;
  final int? subscriber;

  // Extra
  final Map<String, String> extra;

  IrcBadges({
    this.broadcaster = false,
    this.admin = false,
    this.globalMod = false,
    this.staff = false,
    this.moderator = false,
    this.partner = false,
    this.vip = false,
    this.founder = false,
    this.premium = false,
    this.turbo = false,
    this.subscriber,
    this.bits,
    this.bitsLeader,
    this.extra = const {},
  });
}
