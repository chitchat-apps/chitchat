import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/screens/home/channel/emote_menu_tab.dart";
import "package:flutter/material.dart";

class EmoteMenu extends StatefulWidget {
  final Function(Emote emote) onEmoteTap;
  final twitchEmotes = <String, Emote>{};
  final bttvEmotes = <String, Emote>{};
  final ffzEmotes = <String, Emote>{};
  final sevenTvEmotes = <String, Emote>{};
  final twitchGlobalEmotes = <String, Emote>{};
  final bttvGlobalEmotes = <String, Emote>{};
  final ffzGlobalEmotes = <String, Emote>{};
  final sevenTvGlobalEmotes = <String, Emote>{};

  EmoteMenu(
      {super.key,
      required Map<String, Emote> emotes,
      required Map<String, Emote> globalEmotes,
      required this.onEmoteTap}) {
    for (final entry in emotes.entries) {
      switch (entry.value.type) {
        case EmoteType.twitchBits:
        case EmoteType.twitchChannel:
        case EmoteType.twitchFollower:
        case EmoteType.twitchGlobal:
        case EmoteType.twitchSubscriber:
        case EmoteType.twitchUnlocked:
          twitchEmotes[entry.key] = entry.value;
          break;
        case EmoteType.bttvChannel:
        case EmoteType.bttvGlobal:
        case EmoteType.bttvShared:
          bttvEmotes[entry.key] = entry.value;
          break;
        case EmoteType.ffzChannel:
        case EmoteType.ffzGlobal:
          ffzEmotes[entry.key] = entry.value;
          break;
        case EmoteType.sevenTvChannel:
        case EmoteType.sevenTvGlobal:
          sevenTvEmotes[entry.key] = entry.value;
          break;
      }
    }

    for (final entry in globalEmotes.entries) {
      switch (entry.value.type) {
        case EmoteType.twitchBits:
        case EmoteType.twitchChannel:
        case EmoteType.twitchFollower:
        case EmoteType.twitchGlobal:
        case EmoteType.twitchSubscriber:
        case EmoteType.twitchUnlocked:
          twitchGlobalEmotes[entry.key] = entry.value;
          break;
        case EmoteType.bttvChannel:
        case EmoteType.bttvGlobal:
        case EmoteType.bttvShared:
          bttvGlobalEmotes[entry.key] = entry.value;
          break;
        case EmoteType.ffzChannel:
        case EmoteType.ffzGlobal:
          ffzGlobalEmotes[entry.key] = entry.value;
          break;
        case EmoteType.sevenTvChannel:
        case EmoteType.sevenTvGlobal:
          sevenTvGlobalEmotes[entry.key] = entry.value;
          break;
      }
    }
  }

  @override
  State<EmoteMenu> createState() => _EmoteMenuState();
}

class _EmoteMenuState extends State<EmoteMenu> {
  var _index = 0;
  var _query = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ToggleButtons(
                  direction: Axis.horizontal,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  constraints: BoxConstraints.expand(
                    width:
                        constraints.maxWidth / 4 - 2, // subtract 2 for border
                    height: 42,
                  ),
                  isSelected: List.generate(4, (index) => index == _index),
                  onPressed: (index) => setState(() => _index = index),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Twitch",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "BTTV",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "FFZ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "7TV",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: switch (_index) {
                0 => EmoteMenuTab(
                    emotes: _query.isEmpty
                        ? widget.twitchEmotes
                        : {
                            for (final entry in widget.twitchEmotes.entries
                                .where((entry) => entry.key.contains(_query)))
                              entry.key: entry.value
                          },
                    globalEmotes: _query.isEmpty
                        ? widget.twitchGlobalEmotes
                        : {
                            for (final entry in widget
                                .twitchGlobalEmotes.entries
                                .where((entry) => entry.key.contains(_query)))
                              entry.key: entry.value
                          },
                    onEmoteTap: widget.onEmoteTap,
                  ),
                1 => EmoteMenuTab(
                    emotes: _query.isEmpty
                        ? widget.bttvEmotes
                        : {
                            for (final entry in widget.bttvEmotes.entries
                                .where((entry) => entry.key.contains(_query)))
                              entry.key: entry.value
                          },
                    globalEmotes: _query.isEmpty
                        ? widget.bttvGlobalEmotes
                        : {
                            for (final entry in widget.bttvGlobalEmotes.entries
                                .where((entry) => entry.key.contains(
                                    RegExp(_query, caseSensitive: false))))
                              entry.key: entry.value
                          },
                    onEmoteTap: widget.onEmoteTap,
                  ),
                2 => EmoteMenuTab(
                    emotes: _query.isEmpty
                        ? widget.ffzEmotes
                        : {
                            for (final entry in widget.ffzEmotes.entries.where(
                                (entry) => entry.key.contains(
                                    RegExp(_query, caseSensitive: false))))
                              entry.key: entry.value
                          },
                    globalEmotes: _query.isEmpty
                        ? widget.ffzGlobalEmotes
                        : {
                            for (final entry in widget.ffzGlobalEmotes.entries
                                .where((entry) => entry.key.contains(
                                    RegExp(_query, caseSensitive: false))))
                              entry.key: entry.value
                          },
                    onEmoteTap: widget.onEmoteTap,
                  ),
                3 => EmoteMenuTab(
                    emotes: _query.isEmpty
                        ? widget.sevenTvEmotes
                        : {
                            for (final entry in widget.sevenTvEmotes.entries
                                .where((entry) => entry.key.contains(
                                    RegExp(_query, caseSensitive: false))))
                              entry.key: entry.value
                          },
                    globalEmotes: _query.isEmpty
                        ? widget.sevenTvGlobalEmotes
                        : {
                            for (final entry in widget
                                .sevenTvGlobalEmotes.entries
                                .where((entry) => entry.key.contains(
                                    RegExp(_query, caseSensitive: false))))
                              entry.key: entry.value
                          },
                    onEmoteTap: widget.onEmoteTap,
                  ),
                _ => const EmoteMenuTab(),
              },
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: "Search emotes",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 14,
              ),
              maxLines: 1,
              minLines: 1,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
                debugPrint(_query);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
