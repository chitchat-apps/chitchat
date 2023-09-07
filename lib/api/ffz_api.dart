import "dart:convert";

import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/emotes/ffz_emote.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";

class FFZApi {
  static const _ffzBase = "https://api.frankerfacez.com/v1";

  final Client _client;

  FFZApi(this._client);

  Future<List<Emote>> getGlobalEmotes() async {
    final url = Uri.parse("$_ffzBase/set/global");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final defaultSets = decoded["default_sets"] as List;

      final emotes = <FFZEmote>[];

      for (final setId in defaultSets) {
        final emoticons =
            decoded["sets"][setId.toString()]["emoticons"] as List;
        emotes.addAll(emoticons.map((emote) => FFZEmote.fromJson(emote)));
      }

      return emotes
          .map((emote) => Emote.fromFFZ(emote, EmoteType.ffzGlobal))
          .toList();
    }

    return Future.error("Could not fetch FFZ global emotes");
  }

  Future<List<Emote>> getChannelEmotes({required String id}) async {
    final url = Uri.parse("$_ffzBase/room/id/$id");
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final roomSet = decoded["room"]["set"] as int;
      final emotes = decoded["sets"][roomSet.toString()]["emoticons"] as List;

      return emotes
          .map((emote) =>
              Emote.fromFFZ(FFZEmote.fromJson(emote), EmoteType.ffzChannel))
          .toList();
    }

    debugPrint("ID: $id");
    debugPrint(response.body);
    return Future.error("Could not fetch FFZ channel emotes");
  }
}
