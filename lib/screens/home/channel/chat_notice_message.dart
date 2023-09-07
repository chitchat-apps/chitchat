import "package:chitchat/constants.dart";
import "package:chitchat/models/twitch_message.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class NoticeMessage extends StatelessWidget {
  final TwitchMessage message;

  const NoticeMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsStore = context.watch<SettingsStore>();

    final Widget renderMessage;
    Color? errorColor =
        messageBlockNoticeIds.contains(message.messageEvent.tags?["msg-id"])
            ? theme.colorScheme.error
            : null;

    renderMessage = SelectableText.rich(
      TextSpan(
        text: message.messageEvent.message,
        style: TextStyle(fontSize: settingsStore.fontSize),
      ),
      style: TextStyle(
        color: errorColor == null ? theme.hintColor : theme.colorScheme.onError,
        fontWeight: errorColor == null ? null : FontWeight.w500,
      ),
    );

    final paddedMessage = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: renderMessage,
    );

    final coloredMessage = errorColor == null
        ? paddedMessage
        : ColoredBox(color: errorColor, child: paddedMessage);

    return InkWell(
      child: coloredMessage,
    );
  }
}
