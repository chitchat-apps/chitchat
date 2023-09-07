import "dart:convert";

import "package:chitchat/models/emotes/bttv_emote.dart";
import "package:chitchat/models/emotes/emote.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";

class BTTVApi {
  static const _bttvBase = "https://api.betterttv.net/3/cached";

  final Client _client;

  BTTVApi(this._client);

  Future<List<Emote>> getGlobalEmotes() async {
    final url = Uri.parse("$_bttvBase/emotes/global");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final emotes = jsonDecode(response.body) as List;
      return emotes
          .map((emote) =>
              Emote.fromBTTV(BTTVEmote.fromJson(emote), EmoteType.bttvGlobal))
          .toList();
    }

    return Future.error("Could not fetch BTTV global emotes");
  }

  Future<List<Emote>> getChannelEmotes({required String id}) async {
    final url = Uri.parse("$_bttvBase/users/twitch/$id");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final result = BTTVChannelEmote.fromJson(decoded);

      final emotes = <Emote>[];
      emotes.addAll(result.channelEmotes
          .map((emote) => Emote.fromBTTV(emote, EmoteType.bttvChannel)));
      emotes.addAll(result.sharedEmotes
          .map((emote) => Emote.fromBTTV(emote, EmoteType.bttvShared)));
      return emotes;
    }

    debugPrint("ID: $id");
    debugPrint(response.body);
    return Future.error("Could not fetch BTTV channel emotes");
  }
}
