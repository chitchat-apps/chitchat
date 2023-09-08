import "dart:math";

import "package:chitchat/screens/home/channel/emote_menu.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:chitchat/stores/chat_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class ChatInput extends StatefulWidget {
  final ChannelStore channelStore;
  final ChatStore chatStore;

  const ChatInput({
    super.key,
    required this.channelStore,
    required this.chatStore,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  var _showEmotes = false;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final authStore = context.read<AuthStore>();

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: authStore.isAuthenticated
                          ? "Send a message"
                          : "Login to send message",
                      border: const OutlineInputBorder(),
                      enabled: authStore.isAuthenticated,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                          icon: const Icon(Icons.emoji_emotions),
                          color: _showEmotes
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          isSelected: _showEmotes,
                          onPressed: () {
                            setState(() {
                              _showEmotes = !_showEmotes;
                            });
                          },
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: _controller.text.isNotEmpty
                              ? () {
                                  widget.channelStore.send(
                                    channel: widget.chatStore.channel,
                                    message: _controller.text,
                                  );
                                  setState(() {
                                    _controller.clear();
                                  });
                                  _focusNode.requestFocus();
                                }
                              : null,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: null,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      setState(() {
                        _controller.text = value;
                      });
                    },
                    onSubmitted: (value) {
                      widget.channelStore.send(
                        channel: widget.chatStore.channel,
                        message: value,
                      );
                      setState(() {
                        _controller.clear();
                      });
                      _focusNode.requestFocus();
                    },
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            height: _showEmotes
                ? min(MediaQuery.of(context).size.height / 2, 600)
                : 0,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.ease,
              switchOutCurve: Curves.ease,
              child: _showEmotes
                  ? EmoteMenu(
                      emotes: widget.chatStore.emotes,
                      globalEmotes: widget.chatStore.globalEmotes,
                      onEmoteTap: (emote) {
                        setState(() {
                          if (_controller.text.isNotEmpty &&
                              _controller.text[_controller.text.length - 1] !=
                                  " ") {
                            _controller.text += " ";
                          }

                          _controller.text += emote.name;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      );
    });
  }
}
