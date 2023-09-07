import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/models/twitch_user.dart";
import "package:mobx/mobx.dart";

part "user_store.g.dart";

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  final TwitchApi twitchApi;

  @readonly
  TwitchUser? _user;

  UserStoreBase({required this.twitchApi});

  @action
  Future<void> initialize({required Map<String, String> headers}) async {
    _user = await twitchApi.getUser(headers: headers);
  }
}
