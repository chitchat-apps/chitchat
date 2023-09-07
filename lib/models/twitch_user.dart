import "package:json_annotation/json_annotation.dart";

part "twitch_user.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TwitchUser {
  final String id;
  final String login;
  final String displayName;
  final String broadcasterType;
  final String description;
  final String profileImageUrl;

  const TwitchUser({
    required this.id,
    required this.login,
    required this.displayName,
    required this.profileImageUrl,
    required this.broadcasterType,
    required this.description,
  });

  factory TwitchUser.fromJson(Map<String, dynamic> json) =>
      _$TwitchUserFromJson(json);
}


// "id": "141981764",
// "login": "twitchdev",
// "display_name": "TwitchDev",
// "type": "",
// "broadcaster_type": "partner",
// "description": "Supporting third-party developers building Twitch integrations from chatbots to game integrations.",
// "profile_image_url": "https://static-cdn.jtvnw.net/jtv_user_pictures/8a6381c7-d0c0-4576-b179-38bd5ce1d6af-profile_image-300x300.png",
// "offline_image_url": "https://static-cdn.jtvnw.net/jtv_user_pictures/3f13ab61-ec78-4fe6-8481-8682cb3b0ac2-channel_offline_image-1920x1080.png",
// "view_count": 5980557,
// "email": "not-real@email.com",
// "created_at": "2016-12-14T20:32:28Z"