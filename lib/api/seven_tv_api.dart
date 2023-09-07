import "dart:convert";

import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/emotes/seven_tv_emote.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";

class SevenTvApi {
  static const _sevenTvBase = "https://api.7tv.app/v2";

  final Client _client;

  SevenTvApi(this._client);

  Future<List<Emote>> getGlobalEmotes() async {
    final url = Uri.parse("$_sevenTvBase/emotes/global");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final emotes = jsonDecode(response.body) as List;
      return emotes
          .map((emote) => Emote.fromSevenTv(
              SevenTvEmote.fromJson(emote), EmoteType.sevenTvGlobal))
          .toList();
    }

    return Future.error("Could not fetch 7TV global emotes");
  }

  Future<List<Emote>> getChannelEmotes({required String id}) async {
    final url = Uri.parse("$_sevenTvBase/users/$id/emotes");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final emotes = jsonDecode(response.body) as List;
      return emotes
          .map((emote) => Emote.fromSevenTv(
              SevenTvEmote.fromJson(emote), EmoteType.sevenTvChannel))
          .toList();
    }

    debugPrint("ID: $id");
    debugPrint(response.body);
    return Future.error("Could not fetch 7TV channel emotes");
  }
}
