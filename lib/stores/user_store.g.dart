// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on UserStoreBase, Store {
  late final _$_userAtom = Atom(name: 'UserStoreBase._user', context: context);

  TwitchUser? get user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  TwitchUser? get _user => user;

  @override
  set _user(TwitchUser? value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('UserStoreBase.initialize', context: context);

  @override
  Future<void> initialize({required Map<String, String> headers}) {
    return _$initializeAsyncAction
        .run(() => super.initialize(headers: headers));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
