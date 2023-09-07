import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/services/auth_service.dart";
import "package:chitchat/stores/user_store.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:mobx/mobx.dart";

part "auth_store.g.dart";

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final _authService = AuthService();

  final TwitchApi twitchApi;

  late final userStore = UserStore(twitchApi: twitchApi);

  static const _storage = FlutterSecureStorage();

  static const _userTokenKey = "user_token";

  @readonly
  String? _userToken;

  @readonly
  var _isAuthenticated = false;

  @readonly
  var _validUserToken = false;

  @computed
  Map<String, String> get twitchHeaders => {
        "Authorization": "Bearer $_userToken",
        "Client-Id": "cr5v4rf64hsx0n086rmng66l56nr9b",
      };

  AuthStoreBase({required this.twitchApi});

  @action
  Future<void> initialize() async {
    try {
      _userToken = await _storage.read(key: _userTokenKey);
      if (_userToken != null) {
        await authenticate(_userToken!);
      }
    } catch (e) {
      debugPrint("Error initializing auth store: $e");
      // _error = e.toString();
    }
  }

  @action
  Future<bool> signInWithTwitch() async {
    try {
      var userToken = await _authService.signInWithTwitch();
      await authenticate(userToken);
      return userStore.user != null;
    } catch (e) {
      _userToken = null;
      _isAuthenticated = false;
      debugPrint("Error signing in: $e");
      return false;
    }
  }

  @action
  Future<void> authenticate(String token) async {
    try {
      _validUserToken = await twitchApi.validateUserToken(userToken: token);

      if (!_validUserToken) {
        return await signOut();
      }

      _userToken = token;

      await userStore.initialize(headers: twitchHeaders);

      await _storage.write(key: _userTokenKey, value: token);

      _isAuthenticated = userStore.user != null;
    } catch (e) {
      debugPrint("Error authenticating: $e");
    }
  }

  @action
  Future<void> signOut() async {
    try {
      await _storage.delete(key: _userTokenKey);
      _userToken = null;
      _isAuthenticated = false;
      _validUserToken = false;

      debugPrint("Signed out successfully.");
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }
}
