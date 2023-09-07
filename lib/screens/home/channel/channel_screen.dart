import "package:chitchat/screens/home/channel/chat_input.dart";
import "package:chitchat/screens/home/channel/chat_message.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

class ChannelScreen extends StatefulWidget {
  final String channelName;

  final void Function()? onClose;

  const ChannelScreen({super.key, required this.channelName, this.onClose});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  void dispose() {
    debugPrint("Closing channel ${widget.channelName}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final channelStore = context.read<ChannelStore>();
      final channel = channelStore.channels[widget.channelName.toLowerCase()];
      final settingsStore = context.read<SettingsStore>();
      final theme = Theme.of(context);

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          title: channel == null
              ? Text(
                  widget.channelName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            channel.profileImageUrl,
                            height: 28,
                            width: 28,
                            filterQuality: FilterQuality.medium,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  : ColoredBox(
                                      color: theme.primaryColor,
                                      child: SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: Text(
                                          widget.channelName[0].toLowerCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          channel.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      channel.description,
                      maxLines: 1,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
          actions: [
            // only show tooltip if running in debug mode
            if (!const bool.fromEnvironment("dart.vm.product"))
              Tooltip(
                message: channelStore.connected ? "Connected" : "Disconnected",
                child: Icon(
                  channelStore.connected
                      ? Icons.wifi_rounded
                      : Icons.wifi_off_rounded,
                  color: channelStore.connected ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.open_in_new_rounded),
                      SizedBox(width: 8),
                      Text("Open stream"),
                    ],
                  ),
                  onTap: () async {
                    final uri = Uri(
                      scheme: "https",
                      host: "twitch.tv",
                      path: widget.channelName,
                    );

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text("Settings"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.remove_circle),
                      SizedBox(width: 8),
                      Text("Close tab"),
                    ],
                  ),
                  onTap: () {
                    widget.onClose?.call();
                  },
                ),
                if (!const bool.fromEnvironment("dart.vm.product"))
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          channelStore.connected
                              ? Icons.wifi_off_rounded
                              : Icons.wifi_rounded,
                        ),
                        const SizedBox(width: 8),
                        Text(channelStore.connected ? "Disconnect" : "Connect"),
                      ],
                    ),
                    onTap: () {
                      if (channelStore.connected) {
                        channelStore.disconnect();
                      } else {
                        channelStore.connect();
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Observer(
          builder: (context) {
            final chatStore =
                channelStore.chats[widget.channelName.toLowerCase()];

            if (chatStore == null) {
              return const SizedBox();
            }

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chatStore.messages.length,
                      itemBuilder: (context, index) {
                        if (settingsStore.messageDividers) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ChatMessage(
                                message:
                                    chatStore.messages.reversed.toList()[index],
                              ),
                              const Divider(height: 1),
                            ],
                          );
                        }

                        return ChatMessage(
                          message: chatStore.messages.reversed.toList()[index],
                        );
                      },
                    ),
                  ),
                  ChatInput(channelStore: channelStore, chatStore: chatStore),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
