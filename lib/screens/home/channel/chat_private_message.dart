import "package:chitchat/models/badges/chat_badge.dart";
import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/twitch_message.dart";
import "package:chitchat/stores/chat_store.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

class PrivateMessage extends StatelessWidget {
  final TwitchMessage message;
  final ChatStore chatStore;

  const PrivateMessage(
      {super.key, required this.message, required this.chatStore});

  WidgetSpan _createEmoteSpan({
    required Emote emote,
    required SettingsStore settingsStore,
    required BuildContext context,
    required double height,
    double? width,
  }) {
    final isDark = settingsStore.themeMode == ThemeMode.dark ||
        (settingsStore.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Tooltip(
        richMessage: WidgetSpan(
          child: Column(
            children: [
              Image.network(
                emote.url,
                height: height * 2,
                width: width != null ? width * 2 : null,
              ),
              const SizedBox(height: 5),
              Text(
                emote.name,
                style: TextStyle(color: isDark ? Colors.black87 : Colors.white),
              ),
              Text(
                emoteType(emote.type),
                style: TextStyle(color: isDark ? Colors.black87 : Colors.white),
              ),
            ],
          ),
        ),
        preferBelow: false,
        child: Image.network(
          emote.url,
          height: height,
          width: width,
          filterQuality: FilterQuality.medium,
          loadingBuilder: (context, child, loadingProgress) {
            return loadingProgress == null
                ? child
                : SizedBox(
                    width: width,
                    height: height,
                  );
          },
          semanticLabel: emote.name,
        ),
      ),
    );
  }

  WidgetSpan _createBadgeSpan({
    required ChatBadge badge,
    required double size,
    required BuildContext context,
    required SettingsStore settingsStore,
    Color? color,
    bool isSvg = false,
  }) {
    final isDark = settingsStore.themeMode == ThemeMode.dark ||
        (settingsStore.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        preferBelow: false,
        richMessage: WidgetSpan(
          child: Column(
            children: [
              _createBadgeWidget(
                badge: badge,
                size: 80,
                color: color,
                isSvg: isSvg,
              ),
              const SizedBox(height: 5.0),
              Text(
                badge.name,
                style: TextStyle(color: isDark ? Colors.black87 : Colors.white),
              ),
            ],
          ),
        ),
        child: _createBadgeWidget(
          badge: badge,
          size: size,
          color: color,
          isSvg: isSvg,
        ),
      ),
    );
  }

  Widget _createBadgeWidget({
    required ChatBadge badge,
    required double size,
    Color? color,
    bool isSvg = false,
  }) {
    if (color != null) {
      return ColoredBox(
        color: color,
        child: Image.network(
          badge.url,
          height: size,
          width: size,
          filterQuality: FilterQuality.medium,
        ),
      );
    }

    // if (isSvg) {
    //   return
    // }

    return Image.network(
      badge.url,
      height: size,
      width: size,
      filterQuality: FilterQuality.medium,
    );
  }

  bool _isLink(String text) {
    final uri = Uri.tryParse(text);
    if (uri == null) {
      return false;
    }

    return uri.scheme == "http" || uri.scheme == "https";
  }

  Color _getReadableColor(Color color,
      {required BuildContext context, required SettingsStore settingsStore}) {
    final hsl = HSLColor.fromColor(color);
    final isDark = settingsStore.themeMode == ThemeMode.dark ||
        (settingsStore.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    if (isDark) {
      if (hsl.lightness <= 0.5) {
        return hsl
            .withLightness(hsl.lightness + ((1 - hsl.lightness) * 0.25))
            .toColor();
      }
    } else {
      if (hsl.lightness >= 0.5) {
        return hsl
            .withLightness(hsl.lightness + ((0 - hsl.lightness) * 0.25))
            .toColor();
      }
    }

    return color;
  }

  String _getDurationString(int durationSeconds) {
    final duration = Duration(seconds: durationSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      final formattedHours = hours.toString().padLeft(2, "0");
      final formattedMinutes = minutes.toString().padLeft(2, "0");
      return "$formattedHours:$formattedMinutes";
    } else {
      final formattedMinutes = minutes.toString().padLeft(2, "0");
      final formattedSeconds = seconds.toString().padLeft(2, "0");
      return "$formattedMinutes:$formattedSeconds";
    }
  }

  void _openLink({
    required Uri uri,
    required BuildContext context,
  }) {
    // show a confirmation dialog before opening
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Link"),
          content: Text("Are you sure you want to open ${uri.toString()}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Open"),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        launchUrl(uri);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = context.watch<SettingsStore>();
    final theme = Theme.of(context);
    final span = <InlineSpan>[];

    Color? color;
    final Widget renderMessage;

    // check if timestamps are enabled
    if (settingsStore.showTimestamps) {
      final time = message.messageEvent.tags?["tmi-sent-ts"];
      final parsedTime = time == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(int.parse(time));

      if (MediaQuery.of(context).alwaysUse24HourFormat) {
        final timeString = "${parsedTime.hour}:${parsedTime.minute}";
        span.add(
          TextSpan(
            text: "$timeString ",
            style: TextStyle(
              color: theme.hintColor,
            ),
          ),
        );
      } else {
        final timeString = "${parsedTime.hour % 12}:${parsedTime.minute}";
        span.add(
          TextSpan(
            text: "$timeString ${parsedTime.hour > 12 ? "PM" : "AM"} ",
            style: TextStyle(
              color: theme.hintColor,
            ),
          ),
        );
      }
    }

    if (message.messageEvent.isMention) {
      color = Colors.red.withOpacity(0.2);
    }

    final badgeSize =
        20 + ((settingsStore.fontSize - SettingsStore.defaultFontSize) * 2);
    final twitchBadges = message.messageEvent.tags?["badges"]?.split(",");
    if (twitchBadges != null) {
      for (var badgeStr in twitchBadges) {
        final badge =
            chatStore.badges[badgeStr] ?? chatStore.globalBadges[badgeStr];
        if (badge == null) {
          continue;
        }

        span.add(_createBadgeSpan(
          badge: badge,
          size: badgeSize,
          context: context,
          settingsStore: settingsStore,
        ));

        span.add(const TextSpan(text: " "));
      }
    }

    var userColor = Color(int.parse(
        (message.messageEvent.tags?["color"] ?? "#868686")
            .replaceFirst("#", "0xFF")));
    var adjustedUserColor = settingsStore.readableColors
        ? _getReadableColor(
            userColor,
            context: context,
            settingsStore: settingsStore,
          )
        : userColor;

    final displayName =
        message.messageEvent.displayName ?? message.messageEvent.source.nick;
    span.add(
      TextSpan(
        text: displayName,
        style: TextStyle(
          color: adjustedUserColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (message.messageEvent.isAction == false) {
      span.add(const TextSpan(text: ": "));
    }

    if (message.messageEvent.isAction == true) {
      span.add(const TextSpan(text: " "));
    }

    if (message.clear != null && !settingsStore.showDeleted) {
      span.add(const TextSpan(text: "<message deleted>"));
    } else {
      final words = message.messageEvent.message.split(" ");
      for (var i = 0; i < words.length; i++) {
        final word = words[i].trim();
        final emote = message.localEmotes[word] ??
            chatStore.emotes[word] ??
            chatStore.globalEmotes[word];

        if (word.startsWith("@")) {
          span.add(
            TextSpan(
              text: word,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (_isLink(word)) {
          span.add(
            TextSpan(
              text: word,
              style: TextStyle(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final uri = Uri.parse(word);
                  canLaunchUrl(uri).then((value) {
                    if (value) {
                      _openLink(
                        uri: uri,
                        context: context,
                      );
                    }
                  });
                },
            ),
          );
          span.add(const TextSpan(text: " "));
        } else if (emote != null) {
          final emoteScale = settingsStore.emoteScale;
          final emoteSize = 28 +
              ((settingsStore.fontSize - SettingsStore.defaultFontSize) * 2);
          span.add(
            _createEmoteSpan(
              emote: emote,
              height: (emote.height == null
                      ? emoteSize * emoteScale
                      : emote.height! * emoteScale)
                  .toDouble(),
              width: (emote.width == null ? null : emote.width! * emoteScale)
                  ?.toDouble(),
              context: context,
              settingsStore: settingsStore,
            ),
          );
        } else {
          span.add(TextSpan(text: word));
        }

        if (i < words.length - 1) {
          span.add(const TextSpan(text: " "));
        }
      }
    }

    if (message.clear != null) {
      final duration = message.clear!.duration;
      final ban = message.clear!.ban;
      final textStyle = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: settingsStore.fontSize,
      );
      renderMessage = Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText.rich(
              TextSpan(
                children: span,
                style: TextStyle(
                  fontSize: settingsStore.fontSize,
                  decoration: settingsStore.showDeleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              style: TextStyle(color: color),
            ),
            if (settingsStore.showDeletedExtras)
              if (duration != null)
                Text(
                  "(${_getDurationString(int.parse(duration))} Timeout)",
                  style: textStyle,
                )
              else if (ban)
                Text("(Banned)", style: textStyle)
              else if (settingsStore.showDeleted)
                Text("(Deleted)", style: textStyle),
          ],
        ),
      );
    } else {
      renderMessage = SelectableText.rich(
        TextSpan(
          children: span,
          style: TextStyle(fontSize: settingsStore.fontSize),
        ),
        style: TextStyle(color: color),
      );
    }

    final paddedMessage = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: renderMessage,
    );

    final coloredMessage = color == null
        ? paddedMessage
        : ColoredBox(color: color, child: paddedMessage);

    return InkWell(
      child: coloredMessage,
    );
  }
}
