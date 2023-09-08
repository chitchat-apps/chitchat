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
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final channelStore = context.read<ChannelStore>();
      final channel = channelStore.channels[widget.channelName.toLowerCase()];
      final settingsStore = context.read<SettingsStore>();
      final theme = Theme.of(context);

      return RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: (event) {
          final chatStore =
              channelStore.chats[widget.channelName.toLowerCase()];
          if (chatStore != null) {
            if (event.isAltPressed && chatStore.pauseScroll == false) {
              chatStore.suspendScroll();
            } else if (!event.isAltPressed && chatStore.pauseScroll == true) {
              chatStore.resumeScroll();
            }
          }
        },
        child: Scaffold(
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
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                                              color:
                                                  theme.colorScheme.onPrimary,
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
                  message:
                      channelStore.connected ? "Connected" : "Disconnected",
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
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.refresh_rounded),
                        SizedBox(width: 8),
                        Text("Reconnect"),
                      ],
                    ),
                    onTap: () {
                      channelStore.reconnect();
                    },
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
                  if (!const bool.fromEnvironment("dart.vm.product") &&
                      channelStore.connected)
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off_rounded),
                          SizedBox(width: 8),
                          Text("Disconnect"),
                        ],
                      ),
                      onTap: () {
                        channelStore.disconnect();
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
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            reverse: true,
                            itemCount: chatStore.renderMessages.length,
                            controller: chatStore.scrollController,
                            itemBuilder: (context, index) {
                              if (settingsStore.messageDividers) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChatMessage(
                                      message: chatStore.renderMessages.reversed
                                          .toList()[index],
                                    ),
                                    const Divider(height: 1),
                                  ],
                                );
                              }

                              return ChatMessage(
                                message: chatStore.renderMessages.reversed
                                    .toList()[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        ChatInput(
                          channelStore: channelStore,
                          chatStore: chatStore,
                        ),
                      ],
                    ),
                    if (chatStore.pauseScroll)
                      Positioned(
                        left: 0,
                        bottom: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: 0.75,
                              child: FilledButton.tonal(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(0),
                                  ),
                                ),
                                onPressed: () {
                                  chatStore.resumeScroll();
                                  _focusNode.requestFocus();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "Chat paused - press to resume",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
