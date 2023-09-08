import "package:chitchat/models/twitch_stream.dart";
import "package:flutter/material.dart";

class StreamCard extends StatelessWidget {
  final TwitchStream stream;
  final void Function(TwitchStream stream)? onTap;

  const StreamCard({super.key, required this.stream, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleStyle = TextStyle(
      color: theme.hintColor,
      fontSize: 13,
    );

    return ListTile(
      title: Text(
        stream.userName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stream.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                stream.gameName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: subtitleStyle,
              ),
              const Spacer(),
              ClipOval(
                child: Container(
                  color: Colors.red.shade500,
                  height: 7,
                  width: 7,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "${stream.viewerCount} viewers",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: subtitleStyle,
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        onTap?.call(stream);
      },
    );
  }
}
