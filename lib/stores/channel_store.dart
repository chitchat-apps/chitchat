import "dart:async";

import "package:chitchat/api/bttv_api.dart";
import "package:chitchat/api/ffz_api.dart";
import "package:chitchat/api/seven_tv_api.dart";
import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/constants.dart";
import "package:chitchat/models/badges/chat_badge.dart";
import "package:chitchat/models/emotes/emote.dart";
import "package:chitchat/models/pending_message.dart";
import "package:chitchat/models/twitch_message.dart";
import "package:chitchat/models/twitch_user.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:chitchat/stores/chat_store.dart";
import "package:flutter/material.dart";
import "package:mobx/mobx.dart";
import "package:twitch_tmi/twitch_tmi.dart";

part "channel_store.g.dart";

class ChannelStore = ChannelBaseStore with _$ChannelStore;

abstract class ChannelBaseStore with Store {
  final AuthStore auth;
  final TwitchApi twitchApi;
  final FFZApi ffzApi;
  final BTTVApi bttvApi;
  final SevenTvApi sevenTvApi;

  TmiClient? _client;

  StreamSubscription<TmiClientEvent>? _subscription;

  Timer? _refetchTimer;

  @readonly
  var _connected = false;

  @readonly
  var _connecting = false;

  @readonly
  // ignore: prefer_final_fields
  var _chats = ObservableMap<String, ChatStore>();

  @readonly
  // ignore: prefer_final_fields
  var _channels = ObservableMap<String, TwitchUser>();

  @readonly
  var _globalEmotes = <String, Emote>{};

  @readonly
  var _globalBadges = <String, ChatBadge>{};

  @readonly
  // ignore: prefer_final_fields
  var _pendingMessages = <PendingMessage>[];

  ChannelBaseStore({
    required this.auth,
    required this.twitchApi,
    required this.ffzApi,
    required this.bttvApi,
    required this.sevenTvApi,
  });

  @action
  Future<void> initialize({
    List<String>? channels,
    bool isReconnect = false,
  }) async {
    if (auth.userToken == null || !auth.isAuthenticated) {
      return;
    }

    _connecting = true;

    dispose();
    _client = TmiClient(
      username: auth.userStore.user?.login,
      token: auth.userToken,
      channels: channels ?? [],
      autoPong: true,
      logs: true,
      logLevel: Level.info,
    );

    await Future.wait([fetchGlobalBadges(), fetchGlobalEmotes()]);

    if (channels != null) {
      _client!.channels = channels.map((e) => e.toLowerCase()).toList();
    }

    _channels = (await twitchApi.getUsers(
      userLogins: _client!.channels.map((e) => e.toLowerCase()).toList(),
      headers: auth.twitchHeaders,
    ))
        .asObservable();

    final chatFutureList = <Future<void>>[];
    if (isReconnect) {
      for (var channel in _client!.channels) {
        channel = channel.toLowerCase();
        _chats[channel]?.addMessage(TwitchMessage.notice(
          message: "Reconnecting to $channel...",
          channel: channel,
        ));
      }
    } else {
      for (var channel in _client!.channels) {
        channel = channel.toLowerCase();
        _chats[channel] = ChatStore(
          authStore: auth,
          channel: channel,
          twitchApi: twitchApi,
          ffzApi: ffzApi,
          bttvApi: bttvApi,
          sevenTvApi: sevenTvApi,
          globalEmotes: _globalEmotes,
          globalBadges: _globalBadges,
          channelId: _channels[channel]?.id,
        );
        chatFutureList.add(_chats[channel]!.initialize());
      }
    }

    await Future.wait(chatFutureList);

    _client!.connect();

    _subscription = _client!.listen(_handleEvent);

    _refetchTimer = Timer.periodic(refetchDuration, (timer) async {
      debugPrint("Refetching emotes");
      onError(err) {
        // TODO: Handle error
      }

      final futures = <Future<void>>[
        fetchGlobalEmotes().catchError(onError),
        fetchGlobalBadges().catchError(onError)
      ];
      for (final chat in _chats.values) {
        if (chat.channelId == null) {
          continue;
        }

        futures.add(
          chat
              .fetchEmotes(
                channelId: chat.channelId!,
                headers: auth.twitchHeaders,
              )
              .catchError(onError),
        );
        futures.add(
          chat
              .fetchBadges(
                channelId: chat.channelId!,
                headers: auth.twitchHeaders,
              )
              .catchError(onError),
        );
      }

      await Future.wait(futures);
    });
  }

  @action
  void connect() {
    _client?.connect();
  }

  @action
  void disconnect() {
    if (!_connected) {
      return;
    }

    _client?.disconnect();
    _connected = false;
    _connecting = false;
    for (var channel in _client!.channels) {
      channel = channel.toLowerCase();
      _chats[channel]?.addMessage(TwitchMessage.notice(
        message: "Disconnected from $channel",
        channel: channel,
      ));
    }
  }

  @action
  void reconnect() {
    final channels = _chats.keys.toList();
    dispose();
    initialize(channels: channels, isReconnect: true);
  }

  @action
  void send({required String channel, required String message}) {
    final chat = _chats[channel.toLowerCase()];
    if (chat == null) {
      return;
    }

    if (!auth.isAuthenticated || auth.userStore.user == null) {
      chat.addMessage(TwitchMessage.notice(
        message: "Failed to send message: user is not authenticated.",
        channel: channel,
      ));
      return;
    }

    _client?.send(channel: channel, message: message);
    _pendingMessages.add(PendingMessage(
      message: message,
      channel: channel,
    ));
  }

  @action
  Future<void> join(String channel) async {
    channel = channel.toLowerCase();
    final existingChat = _chats[channel];
    if (existingChat != null) {
      return;
    }

    final channelObj = await twitchApi.getUser(
        userLogin: channel, headers: auth.twitchHeaders);
    _channels[channel] = channelObj;

    final chat = ChatStore(
      authStore: auth,
      channel: channel,
      twitchApi: twitchApi,
      ffzApi: ffzApi,
      bttvApi: bttvApi,
      sevenTvApi: sevenTvApi,
      globalEmotes: _globalEmotes,
      globalBadges: _globalBadges,
      channelId: channelObj.id,
    );
    await chat.initialize();
    _chats[channel] = chat;
    _client?.join(channel);
  }

  @action
  void part(String channel) {
    channel = channel.toLowerCase();
    _client?.part(channel);
    _chats[channel]!.dispose();
    _chats.remove(channel);
  }

  @action
  Future<void> fetchGlobalEmotes() async {
    onError(err) {
      debugPrint("Error fetching emotes: $err");
      return <Emote>[];
    }

    final result = await Future.wait([
      twitchApi
          .getGlobalEmotes(headers: auth.twitchHeaders)
          .catchError(onError),
      ffzApi.getGlobalEmotes().catchError(onError),
      bttvApi.getGlobalEmotes().catchError(onError),
      sevenTvApi.getGlobalEmotes().catchError(onError),
    ]);

    _globalEmotes = {
      for (final emote in result.expand((emotes) => emotes)) emote.name: emote
    };
  }

  @action
  Future<void> fetchGlobalBadges() async {
    onError(err) {
      debugPrint("Error fetching badges: $err");
      return <String, ChatBadge>{};
    }

    final result = await Future.wait([
      twitchApi
          .getGlobalBadges(headers: auth.twitchHeaders)
          .catchError(onError),
      // ffzApi.getGlobalEmotes().catchError(onError),
      // bttvApi.getGlobalEmotes().catchError(onError),
      // sevenTvApi.getGlobalEmotes().catchError(onError),
    ]);

    _globalBadges = {
      for (final badge in result.expand((badges) => badges.entries))
        badge.key: badge.value
    };
  }

  @action
  Future<void> reset() async {
    _refetchTimer?.cancel();
    _refetchTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _chats.clear();
    _channels.clear();
    _globalEmotes.clear();
    _globalBadges.clear();

    await initialize(channels: []);
  }

  @action
  void _handleEvent(TmiClientEvent event) {
    switch (event.type) {
      case TmiClientEventType.message:
        final messageEvent = event as TmiClientMessageEvent;
        if (messageEvent.isNotice) {
          if (messageBlockNoticeIds.contains(messageEvent.tags?["msg-id"])) {
            final pendingMessageIndex = _pendingMessages.indexWhere(
              (element) => element.channel == messageEvent.channel,
            );
            if (pendingMessageIndex != -1) {
              _pendingMessages.removeAt(pendingMessageIndex);
            }
          }
        }

        _chats[messageEvent.channel]!.addMessage(TwitchMessage(
          messageEvent: messageEvent,
        ));
        break;
      case TmiClientEventType.clearChat:
        final clearChatEvent = event as TmiClientClearChatEvent;
        _clearChat(clearChatEvent);
        break;
      case TmiClientEventType.clearMessage:
        final clearMessageEvent = event as TmiClientClearMessageEvent;
        _clearMessage(clearMessageEvent);
        break;
      case TmiClientEventType.userState:
        final userStateEvent = event as TmiClientUserStateEvent;
        final chat = _chats[userStateEvent.channel];

        final pendingMessageIndex = _pendingMessages.indexWhere(
          (element) => element.channel == userStateEvent.channel,
        );
        if (pendingMessageIndex != -1 && chat != null) {
          final pendingMessage = _pendingMessages.removeAt(pendingMessageIndex);
          chat.addMessage(
            TwitchMessage.fromPending(pendingMessage, userStateEvent),
          );
        }
        break;
      case TmiClientEventType.connected:
        _connected = true;
        _connecting = false;
        break;
      case TmiClientEventType.disconnected:
        disconnect();
        break;
      case TmiClientEventType.error:
        final errorEvent = event as TmiClientErrorEvent;
        debugPrint("Error: ${errorEvent.message}");
        break;
      case TmiClientEventType.raw:
        break;
      default:
        break;
    }
  }

  @action
  void _clearMessage(TmiClientClearMessageEvent event) {
    final chat = _chats[event.channel.toLowerCase()];
    if (chat == null) {
      return;
    }

    for (var i = 0; i < chat.messages.length; i++) {
      final message = chat.messages[i];
      if (message.messageEvent.tags?["id"] == event.targetId) {
        message.clear = ClearMessage();
        break;
      }
    }
  }

  @action
  void _clearChat(TmiClientClearChatEvent event) {
    final chat = _chats[event.channel.toLowerCase()];
    if (chat == null) {
      return;
    }

    if (event.user == null) {
      chat.messages.clear();
      chat.messages.add(
        TwitchMessage.notice(
          message: "Chat was cleared by a moderator",
          channel: event.channel,
        ),
      );
      return;
    }

    for (var i = 0; i < chat.messages.length; i++) {
      final message = chat.messages[i];
      if (message.messageEvent.source.nick == event.user) {
        message.clear = ClearMessage(
          duration: event.duration,
          ban: event.duration == null,
        );
      }
    }
  }

  void dispose() {
    _refetchTimer?.cancel();
    _refetchTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _client?.dispose();
  }
}
