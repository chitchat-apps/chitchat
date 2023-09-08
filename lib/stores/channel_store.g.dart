// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChannelStore on ChannelBaseStore, Store {
  late final _$_connectedAtom =
      Atom(name: 'ChannelBaseStore._connected', context: context);

  bool get connected {
    _$_connectedAtom.reportRead();
    return super._connected;
  }

  @override
  bool get _connected => connected;

  @override
  set _connected(bool value) {
    _$_connectedAtom.reportWrite(value, super._connected, () {
      super._connected = value;
    });
  }

  late final _$_connectingAtom =
      Atom(name: 'ChannelBaseStore._connecting', context: context);

  bool get connecting {
    _$_connectingAtom.reportRead();
    return super._connecting;
  }

  @override
  bool get _connecting => connecting;

  @override
  set _connecting(bool value) {
    _$_connectingAtom.reportWrite(value, super._connecting, () {
      super._connecting = value;
    });
  }

  late final _$_chatsAtom =
      Atom(name: 'ChannelBaseStore._chats', context: context);

  ObservableMap<String, ChatStore> get chats {
    _$_chatsAtom.reportRead();
    return super._chats;
  }

  @override
  ObservableMap<String, ChatStore> get _chats => chats;

  @override
  set _chats(ObservableMap<String, ChatStore> value) {
    _$_chatsAtom.reportWrite(value, super._chats, () {
      super._chats = value;
    });
  }

  late final _$_channelsAtom =
      Atom(name: 'ChannelBaseStore._channels', context: context);

  ObservableMap<String, TwitchUser> get channels {
    _$_channelsAtom.reportRead();
    return super._channels;
  }

  @override
  ObservableMap<String, TwitchUser> get _channels => channels;

  @override
  set _channels(ObservableMap<String, TwitchUser> value) {
    _$_channelsAtom.reportWrite(value, super._channels, () {
      super._channels = value;
    });
  }

  late final _$_globalEmotesAtom =
      Atom(name: 'ChannelBaseStore._globalEmotes', context: context);

  Map<String, Emote> get globalEmotes {
    _$_globalEmotesAtom.reportRead();
    return super._globalEmotes;
  }

  @override
  Map<String, Emote> get _globalEmotes => globalEmotes;

  @override
  set _globalEmotes(Map<String, Emote> value) {
    _$_globalEmotesAtom.reportWrite(value, super._globalEmotes, () {
      super._globalEmotes = value;
    });
  }

  late final _$_globalBadgesAtom =
      Atom(name: 'ChannelBaseStore._globalBadges', context: context);

  Map<String, ChatBadge> get globalBadges {
    _$_globalBadgesAtom.reportRead();
    return super._globalBadges;
  }

  @override
  Map<String, ChatBadge> get _globalBadges => globalBadges;

  @override
  set _globalBadges(Map<String, ChatBadge> value) {
    _$_globalBadgesAtom.reportWrite(value, super._globalBadges, () {
      super._globalBadges = value;
    });
  }

  late final _$_pendingMessagesAtom =
      Atom(name: 'ChannelBaseStore._pendingMessages', context: context);

  List<PendingMessage> get pendingMessages {
    _$_pendingMessagesAtom.reportRead();
    return super._pendingMessages;
  }

  @override
  List<PendingMessage> get _pendingMessages => pendingMessages;

  @override
  set _pendingMessages(List<PendingMessage> value) {
    _$_pendingMessagesAtom.reportWrite(value, super._pendingMessages, () {
      super._pendingMessages = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('ChannelBaseStore.initialize', context: context);

  @override
  Future<void> initialize({List<String>? channels, bool isReconnect = false}) {
    return _$initializeAsyncAction.run(
        () => super.initialize(channels: channels, isReconnect: isReconnect));
  }

  late final _$joinAsyncAction =
      AsyncAction('ChannelBaseStore.join', context: context);

  @override
  Future<void> join(String channel) {
    return _$joinAsyncAction.run(() => super.join(channel));
  }

  late final _$fetchGlobalEmotesAsyncAction =
      AsyncAction('ChannelBaseStore.fetchGlobalEmotes', context: context);

  @override
  Future<void> fetchGlobalEmotes() {
    return _$fetchGlobalEmotesAsyncAction.run(() => super.fetchGlobalEmotes());
  }

  late final _$fetchGlobalBadgesAsyncAction =
      AsyncAction('ChannelBaseStore.fetchGlobalBadges', context: context);

  @override
  Future<void> fetchGlobalBadges() {
    return _$fetchGlobalBadgesAsyncAction.run(() => super.fetchGlobalBadges());
  }

  late final _$resetAsyncAction =
      AsyncAction('ChannelBaseStore.reset', context: context);

  @override
  Future<void> reset() {
    return _$resetAsyncAction.run(() => super.reset());
  }

  late final _$ChannelBaseStoreActionController =
      ActionController(name: 'ChannelBaseStore', context: context);

  @override
  void connect() {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore.connect');
    try {
      return super.connect();
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disconnect() {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore.disconnect');
    try {
      return super.disconnect();
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reconnect() {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore.reconnect');
    try {
      return super.reconnect();
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void send({required String channel, required String message}) {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore.send');
    try {
      return super.send(channel: channel, message: message);
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void part(String channel) {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore.part');
    try {
      return super.part(channel);
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleEvent(TmiClientEvent event) {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore._handleEvent');
    try {
      return super._handleEvent(event);
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearMessage(TmiClientClearMessageEvent event) {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore._clearMessage');
    try {
      return super._clearMessage(event);
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearChat(TmiClientClearChatEvent event) {
    final _$actionInfo = _$ChannelBaseStoreActionController.startAction(
        name: 'ChannelBaseStore._clearChat');
    try {
      return super._clearChat(event);
    } finally {
      _$ChannelBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
