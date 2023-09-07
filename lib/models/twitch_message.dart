import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/pending_message.dart";
import "package:twitch_tmi/twitch_tmi.dart";

class TwitchMessage {
  final TmiClientMessageEvent messageEvent;
  late final Map<String, Emote> localEmotes;

  ClearMessage? clear;

  TwitchMessage({required this.messageEvent, this.clear}) {
    localEmotes = _parseLocalEmotes();
  }

  factory TwitchMessage.fromEvent(TmiClientMessageEvent event) {
    return TwitchMessage(messageEvent: event);
  }

  factory TwitchMessage.fromPending(
    PendingMessage pendingMessage,
    TmiClientUserStateEvent userState,
  ) =>
      TwitchMessage(
        messageEvent: TmiClientMessageEvent(
          message: pendingMessage.message,
          channel: pendingMessage.channel,
          source: Source(
            raw:
                ":${userState.source.nick}!${userState.source.nick}.tmi.twitch.tv",
            host: "${userState.source.nick}.tmi.twitch.tv",
            nick: "${userState.source.nick}",
          ),
          commandType: CommandType.privMsg,
          displayName: userState.displayName,
          isAction: false,
          isSelf: true,
          tags: userState.tags,
        ),
      );

  factory TwitchMessage.notice({
    required String message,
    required String channel,
  }) {
    return TwitchMessage(
      messageEvent: TmiClientMessageEvent(
        message: message,
        channel: channel,
        source: Source(
          raw: ":tmi.twitch.tv",
          host: "tmi.twitch.tv",
        ),
        commandType: CommandType.notice,
        isNotice: true,
      ),
    );
  }

  Map<String, Emote> _parseLocalEmotes() {
    final emotes = messageEvent.tags?["emotes"]?.split("/");
    if (emotes == null) {
      return {};
    }

    final emoteMap = <String, Emote>{};
    for (final emoteStrObj in emotes) {
      final sepIndex = emoteStrObj.indexOf(":");
      final emoteId = emoteStrObj.substring(0, sepIndex);

      final String range;
      if (emoteStrObj.contains(",")) {
        range = emoteStrObj.substring(sepIndex + 1, emoteStrObj.indexOf(","));
      } else {
        range = emoteStrObj.substring(sepIndex + 1);
      }

      final indexSplit = range.split("-");
      final startIndex = int.parse(indexSplit[0]);
      final endIndex = int.parse(indexSplit[1]);

      final emoteWord =
          messageEvent.message.substring(startIndex, endIndex + 1);
      emoteMap[emoteWord] = Emote(
        name: emoteWord,
        zeroWidth: false,
        url:
            "https://static-cdn.jtvnw.net/emoticons/v2/$emoteId/default/dark/3.0",
        type: EmoteType.twitchSubscriber,
      );
    }

    return emoteMap;
  }
}

class ClearMessage {
  final String? duration;
  final bool ban;

  ClearMessage({this.duration, this.ban = false});
}
