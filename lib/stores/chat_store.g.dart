// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on ChatBaseStore, Store {
  late final _$_messagesAtom =
      Atom(name: 'ChatBaseStore._messages', context: context);

  ObservableList<TwitchMessage> get messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  ObservableList<TwitchMessage> get _messages => messages;

  @override
  set _messages(ObservableList<TwitchMessage> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  late final _$_emotesAtom =
      Atom(name: 'ChatBaseStore._emotes', context: context);

  Map<String, Emote> get emotes {
    _$_emotesAtom.reportRead();
    return super._emotes;
  }

  @override
  Map<String, Emote> get _emotes => emotes;

  @override
  set _emotes(Map<String, Emote> value) {
    _$_emotesAtom.reportWrite(value, super._emotes, () {
      super._emotes = value;
    });
  }

  late final _$_globalEmotesAtom =
      Atom(name: 'ChatBaseStore._globalEmotes', context: context);

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

  late final _$_badgesAtom =
      Atom(name: 'ChatBaseStore._badges', context: context);

  Map<String, ChatBadge> get badges {
    _$_badgesAtom.reportRead();
    return super._badges;
  }

  @override
  Map<String, ChatBadge> get _badges => badges;

  @override
  set _badges(Map<String, ChatBadge> value) {
    _$_badgesAtom.reportWrite(value, super._badges, () {
      super._badges = value;
    });
  }

  late final _$_globalBadgesAtom =
      Atom(name: 'ChatBaseStore._globalBadges', context: context);

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

  late final _$initializeAsyncAction =
      AsyncAction('ChatBaseStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$fetchEmotesAsyncAction =
      AsyncAction('ChatBaseStore.fetchEmotes', context: context);

  @override
  Future<void> fetchEmotes(
      {required String channelId, required Map<String, String> headers}) {
    return _$fetchEmotesAsyncAction
        .run(() => super.fetchEmotes(channelId: channelId, headers: headers));
  }

  late final _$fetchBadgesAsyncAction =
      AsyncAction('ChatBaseStore.fetchBadges', context: context);

  @override
  Future<void> fetchBadges(
      {required String channelId, required Map<String, String> headers}) {
    return _$fetchBadgesAsyncAction
        .run(() => super.fetchBadges(channelId: channelId, headers: headers));
  }

  late final _$ChatBaseStoreActionController =
      ActionController(name: 'ChatBaseStore', context: context);

  @override
  void addMessage(TwitchMessage event) {
    final _$actionInfo = _$ChatBaseStoreActionController.startAction(
        name: 'ChatBaseStore.addMessage');
    try {
      return super.addMessage(event);
    } finally {
      _$ChatBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
