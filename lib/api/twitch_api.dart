import "dart:convert";

import "package:chitchat/models/badges/twitch_badge.dart";
import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/emotes/twitch_emote.dart";
import "package:chitchat/models/twitch_channel.dart";
import "package:chitchat/models/twitch_user.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";
import "package:chitchat/models/badges/chat_badge.dart";

class TwitchApi {
  static const _oauthBase = "https://id.twitch.tv/oauth2";
  static const _helixBase = "https://api.twitch.tv/helix";

  final Client _client;

  TwitchApi(this._client);

  Future<List<Emote>> getGlobalEmotes(
      {required Map<String, String> headers}) async {
    final url = Uri.parse("$_helixBase/chat/emotes/global");
    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)["data"] as List;
      return decoded
          .map((emote) => TwitchEmote.fromJson(emote))
          .map((emote) => Emote.fromTwitch(emote, EmoteType.twitchGlobal))
          .toList();
    }

    return Future.error("Could not fetch Twitch global emotes.");
  }

  Future<List<Emote>> getChannelEmotes(
      {required String id, required Map<String, String> headers}) async {
    final url = Uri.parse("$_helixBase/chat/emotes?broadcaster_id=$id");
    final response = await _client.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)["data"] as List;
      final emotes = decoded.map((emote) => TwitchEmote.fromJson(emote));

      return emotes.map((emote) {
        switch (emote.emoteType) {
          case "bitstier":
            return Emote.fromTwitch(emote, EmoteType.twitchBits);
          case "follower":
            return Emote.fromTwitch(emote, EmoteType.twitchFollower);
          case "subscriptions":
            return Emote.fromTwitch(emote, EmoteType.twitchChannel);
          default:
            return Emote.fromTwitch(emote, EmoteType.twitchChannel);
        }
      }).toList();
    }

    debugPrint("ID: $id");
    return Future.error("Could not fetch Twitch channel emotes.");
  }

  Future<List<Emote>> getEmotesSets({
    required String setId,
    required Map<String, String> headers,
  }) async {
    final url = Uri.parse("$_helixBase/chat/emotes/set?emote_set_id=$setId");
    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)["data"] as List;
      final emotes = decoded.map((emote) => TwitchEmote.fromJson(emote));

      return emotes.map((emote) {
        switch (emote.emoteType) {
          case "globals":
          case "smilies":
            return Emote.fromTwitch(emote, EmoteType.twitchGlobal);
          case "subscriptions":
            return Emote.fromTwitch(emote, EmoteType.twitchSubscriber);
          default:
            return Emote.fromTwitch(emote, EmoteType.twitchUnlocked);
        }
      }).toList();
    }

    return Future.error("Could not fetch Twitch emotes set.");
  }

  Future<Map<String, ChatBadge>> getGlobalBadges(
      {required Map<String, String> headers}) async {
    final url = Uri.parse("$_helixBase/chat/badges/global");

    final response = await _client.get(url, headers: headers);
    if (response.statusCode == 200) {
      final result = <String, ChatBadge>{};
      final decoded = jsonDecode(response.body)["data"] as List;

      for (final badge in decoded) {
        final id = badge["set_id"] as String;
        final versions = badge["versions"] as List;

        for (final version in versions) {
          final badgeInfo = TwitchBadge.fromJson(version);
          result["$id/${badgeInfo.id}"] = ChatBadge.fromTwitch(badgeInfo);
        }
      }

      return result;
    }

    return Future.error("Could not fetch Twitch global badges.");
  }

  Future<Map<String, ChatBadge>> getChannelBadges({
    required String id,
    required Map<String, String> headers,
  }) async {
    final url = Uri.parse("$_helixBase/chat/badges?broadcaster_id=$id");
    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final result = <String, ChatBadge>{};
      final decoded = jsonDecode(response.body)["data"] as List;

      for (final badge in decoded) {
        final id = badge["set_id"] as String;
        final versions = badge["versions"] as List;

        for (final version in versions) {
          final badgeInfo = TwitchBadge.fromJson(version);
          result["$id/${badgeInfo.id}"] = ChatBadge.fromTwitch(badgeInfo);
        }
      }

      return result;
    }

    return Future.error("Could not fetch Twitch channel badges.");
  }

  Future<Map<String, TwitchUser>> getUsers({
    required List<String> userLogins,
    required Map<String, String> headers,
  }) async {
    if (userLogins.isEmpty) {
      return {};
    }

    final String query = userLogins.join("&login=");
    final uri = Uri.parse("$_helixBase/users?login=$query");

    final response = await _client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded["data"] as List;

      return {
        for (final user in data.map((user) => TwitchUser.fromJson(user)))
          user.login: user
      };
    }

    return Future.error("Could not fetch channels.");
  }

  Future<TwitchUser> getUser({
    required Map<String, String> headers,
    String? userLogin,
  }) async {
    if (userLogin != null) {
      var user = (await getUsers(
          userLogins: [userLogin], headers: headers))[userLogin];
      if (user != null) {
        return user;
      }
    } else {
      final url = Uri.parse("$_helixBase/users");
      final response = await _client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded["data"] as List;

        return TwitchUser.fromJson(data.first);
      }
    }

    return Future.error("Could not fetch Twitch user.");
  }

  Future<TwitchChannel?> getChannel({
    required String userLogin,
    required Map<String, String> headers,
  }) async {
    final uri = Uri.parse("$_helixBase/streams?user_login=$userLogin");

    final response = await _client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded["data"] as List;

      if (data.isNotEmpty) {
        return TwitchChannel.fromJson(data.first);
      }

      return null;
    }

    return Future.error("Could not fetch stream info");
  }

  Future<bool> validateUserToken({required String userToken}) async {
    final url = Uri.parse("$_oauthBase/validate");
    final response =
        await _client.get(url, headers: {"Authorization": "Bearer $userToken"});
    return response.statusCode == 200;
  }
}
