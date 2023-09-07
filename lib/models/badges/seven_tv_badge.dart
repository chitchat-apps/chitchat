import "package:json_annotation/json_annotation.dart";

part "seven_tv_badge.g.dart";

@JsonSerializable()
class SevenTvBadge {
  final String tooltip;
  final List<List<String>> urls;
  final List<String> users;

  SevenTvBadge({
    required this.tooltip,
    required this.urls,
    required this.users,
  });
}
