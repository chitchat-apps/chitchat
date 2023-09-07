// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on AuthStoreBase, Store {
  Computed<Map<String, String>>? _$twitchHeadersComputed;

  @override
  Map<String, String> get twitchHeaders => (_$twitchHeadersComputed ??=
          Computed<Map<String, String>>(() => super.twitchHeaders,
              name: 'AuthStoreBase.twitchHeaders'))
      .value;

  late final _$_userTokenAtom =
      Atom(name: 'AuthStoreBase._userToken', context: context);

  String? get userToken {
    _$_userTokenAtom.reportRead();
    return super._userToken;
  }

  @override
  String? get _userToken => userToken;

  @override
  set _userToken(String? value) {
    _$_userTokenAtom.reportWrite(value, super._userToken, () {
      super._userToken = value;
    });
  }

  late final _$_isAuthenticatedAtom =
      Atom(name: 'AuthStoreBase._isAuthenticated', context: context);

  bool get isAuthenticated {
    _$_isAuthenticatedAtom.reportRead();
    return super._isAuthenticated;
  }

  @override
  bool get _isAuthenticated => isAuthenticated;

  @override
  set _isAuthenticated(bool value) {
    _$_isAuthenticatedAtom.reportWrite(value, super._isAuthenticated, () {
      super._isAuthenticated = value;
    });
  }

  late final _$_validUserTokenAtom =
      Atom(name: 'AuthStoreBase._validUserToken', context: context);

  bool get validUserToken {
    _$_validUserTokenAtom.reportRead();
    return super._validUserToken;
  }

  @override
  bool get _validUserToken => validUserToken;

  @override
  set _validUserToken(bool value) {
    _$_validUserTokenAtom.reportWrite(value, super._validUserToken, () {
      super._validUserToken = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('AuthStoreBase.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$signInWithTwitchAsyncAction =
      AsyncAction('AuthStoreBase.signInWithTwitch', context: context);

  @override
  Future<bool> signInWithTwitch() {
    return _$signInWithTwitchAsyncAction.run(() => super.signInWithTwitch());
  }

  late final _$authenticateAsyncAction =
      AsyncAction('AuthStoreBase.authenticate', context: context);

  @override
  Future<void> authenticate(String token) {
    return _$authenticateAsyncAction.run(() => super.authenticate(token));
  }

  late final _$signOutAsyncAction =
      AsyncAction('AuthStoreBase.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  @override
  String toString() {
    return '''
twitchHeaders: ${twitchHeaders}
    ''';
  }
}
