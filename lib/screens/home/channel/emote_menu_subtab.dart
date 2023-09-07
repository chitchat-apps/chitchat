import "package:chitchat/models/emotes/emote.dart";
import "package:flutter/material.dart";

class EmoteMenuSubTab extends StatelessWidget {
  final Map<String, Emote>? emotes;
  final Function(Emote emote)? onEmoteTap;

  const EmoteMenuSubTab({
    super.key,
    this.emotes,
    this.onEmoteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (emotes == null || emotes!.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No emotes found",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ],
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 50,
      ),
      itemCount: emotes!.length,
      itemBuilder: (context, index) {
        final emote = emotes!.values.toList()[index];
        return InkWell(
          onTap: () => onEmoteTap?.call(emote),
          borderRadius: BorderRadius.circular(4),
          child: Tooltip(
            waitDuration: const Duration(milliseconds: 500),
            message: emote.name,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Image.network(
                  emote.url,
                  height: emote.height?.toDouble() ?? 28,
                  width: emote.width?.toDouble() ?? 28,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: emote.height?.toDouble() ?? 28,
                    width: emote.width?.toDouble() ?? 28,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    child: Icon(
                      Icons.broken_image,
                      size: 22,
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
