import "package:chitchat/models/twitch_message.dart";
import "package:chitchat/screens/home/channel/chat_notice_message.dart";
import "package:chitchat/screens/home/channel/chat_private_message.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ChatMessage extends StatelessWidget {
  final TwitchMessage message;

  const ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final chatStore =
        context.read<ChannelStore>().chats[message.messageEvent.channel]!;

    if (message.messageEvent.isNotice) {
      return NoticeMessage(message: message);
    } else {
      return PrivateMessage(message: message, chatStore: chatStore);
    }
  }
}
