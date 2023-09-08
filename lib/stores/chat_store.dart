import "dart:async";

import "package:chitchat/api/bttv_api.dart";
import "package:chitchat/api/ffz_api.dart";
import "package:chitchat/api/seven_tv_api.dart";
import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/models/badges/chat_badge.dart";
import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/twitch_message.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:flutter/material.dart";
import "package:mobx/mobx.dart";

part "chat_store.g.dart";

class ChatStore = ChatBaseStore with _$ChatStore;

abstract class ChatBaseStore with Store {
  final AuthStore authStore;
  final TwitchApi twitchApi;
  final FFZApi ffzApi;
  final BTTVApi bttvApi;
  final SevenTvApi sevenTvApi;
  final String channel;
  final String? channelId;

  static const _messageLimit = 5000;

  final _messagesToRemove = (_messageLimit * 0.2).toInt();

  final scrollController = ScrollController();

  late final Timer _messageBufferTimer;

  final _messageBuffer = <TwitchMessage>[];

  @readonly
  var _pauseScroll = false;

  @readonly
  // ignore: prefer_final_fields
  var _messages = ObservableList<TwitchMessage>();

  @readonly
  // ignore: prefer_final_fields
  Map<String, Emote> _emotes = {};

  @readonly
  // ignore: prefer_final_fields
  Map<String, Emote> _globalEmotes;

  @readonly
  // ignore: prefer_final_fields
  Map<String, ChatBadge> _badges = {};

  @readonly
  // ignore: prefer_final_fields
  Map<String, ChatBadge> _globalBadges;

  ChatBaseStore({
    required this.authStore,
    required this.channel,
    required this.twitchApi,
    required this.ffzApi,
    required this.bttvApi,
    required this.sevenTvApi,
    required Map<String, Emote> globalEmotes,
    required Map<String, ChatBadge> globalBadges,
    this.channelId,
  })  : _globalEmotes = globalEmotes,
        _globalBadges = globalBadges;

  @computed
  List<TwitchMessage> get renderMessages {
    if (_pauseScroll || _messages.length < _messageLimit) {
      return _messages;
    }

    return _messages.sublist(
      _messages.length - _messageLimit,
      _messages.length,
    );
  }

  @action
  void addMessage(TwitchMessage message) {
    _messageBuffer.add(message);
    if (_messageBuffer.length >= _messageLimit) {
      _messageBuffer.removeRange(0, _messagesToRemove);
    }
  }

  @action
  void updateMessages() {
    if (_pauseScroll || _messageBuffer.isEmpty) {
      return;
    }

    _messages.addAll(_messageBuffer);
    _messageBuffer.clear();
    if (_messages.length >= _messageLimit) {
      _messages.removeRange(0, _messagesToRemove);
    }
  }

  @action
  Future<void> initialize() async {
    _messages.add(TwitchMessage.notice(
      message: "Connecting to $channel...",
      channel: channel,
    ));

    scrollController.addListener(() {
      if (scrollController.position.pixels > 0) {
        _pauseScroll = true;
      }
    });

    _messageBufferTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => updateMessages(),
    );

    if (channelId != null) {
      await Future.wait([
        fetchEmotes(
          channelId: channelId!,
          headers: authStore.twitchHeaders,
        ),
        fetchBadges(
          channelId: channelId!,
          headers: authStore.twitchHeaders,
        ),
      ]);
    }
  }

  @action
  Future<void> fetchEmotes({
    required String channelId,
    required Map<String, String> headers,
  }) async {
    onError(err) {
      debugPrint("Error fetching emotes: $err");
      return <Emote>[];
    }

    final result = await Future.wait([
      twitchApi
          .getChannelEmotes(
            id: channelId,
            headers: headers,
          )
          .catchError(onError),
      ffzApi.getChannelEmotes(id: channelId).catchError(onError),
      bttvApi.getChannelEmotes(id: channelId).catchError(onError),
      sevenTvApi.getChannelEmotes(id: channelId).catchError(onError),
    ]);

    _emotes = {
      for (final emote in result.expand((emotes) => emotes)) emote.name: emote
    };
  }

  @action
  Future<void> fetchBadges({
    required String channelId,
    required Map<String, String> headers,
  }) async {
    onError(err) {
      debugPrint("Error fetching badges: $err");
      return <String, ChatBadge>{};
    }

    final result = await Future.wait([
      twitchApi
          .getChannelBadges(
            id: channelId,
            headers: headers,
          )
          .catchError(onError),
      // ffzApi.getGlobalEmotes().catchError(onError),
      // bttvApi.getGlobalEmotes().catchError(onError),
      // sevenTvApi.getGlobalEmotes().catchError(onError),
    ]);

    _badges = {
      for (final badge in result.expand((badges) => badges.entries))
        badge.key: badge.value
    };
  }

  @action
  void suspendScroll() {
    _pauseScroll = true;
  }

  @action
  void resumeScroll() {
    _pauseScroll = false;
    scrollController.jumpTo(0);
  }

  @action
  void dispose() {
    _messageBufferTimer.cancel();
    scrollController.dispose();

    // _messages.add(TwitchMessage.notice(
    //   message: "Disconnected from $channel",
    //   channel: channel,
    // ));
  }
}
