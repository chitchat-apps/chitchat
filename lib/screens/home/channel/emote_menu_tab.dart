import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/screens/home/channel/emote_menu_subtab.dart";
import "package:flutter/material.dart";

class EmoteMenuTab extends StatefulWidget {
  final Map<String, Emote>? emotes;
  final Map<String, Emote>? globalEmotes;
  final Function(Emote emote)? onEmoteTap;

  const EmoteMenuTab({
    super.key,
    this.emotes,
    this.globalEmotes,
    this.onEmoteTap,
  });

  @override
  State<EmoteMenuTab> createState() => _EmoteMenuTabState();
}

class _EmoteMenuTabState extends State<EmoteMenuTab> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  width: constraints.maxWidth / 2 - 2, // subtract 2 for border
                  height: 42,
                ),
                isSelected: List.generate(2, (index) => index == _index),
                onPressed: (index) => setState(() => _index = index),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Global",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Channel",
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
              0 => EmoteMenuSubTab(
                  emotes: widget.globalEmotes,
                  onEmoteTap: widget.onEmoteTap,
                ),
              1 => EmoteMenuSubTab(
                  emotes: widget.emotes,
                  onEmoteTap: widget.onEmoteTap,
                ),
              _ => const EmoteMenuSubTab(),
            },
          ),
        ],
      ),
    );
  }
}
