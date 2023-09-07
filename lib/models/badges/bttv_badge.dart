import "package:json_annotation/json_annotation.dart";

part "bttv_badge.g.dart";

@JsonSerializable()
class BTTVBadge {
  final String providerId;
  final BTTVBadgeDetails badge;

  BTTVBadge({
    required this.providerId,
    required this.badge,
  });

  factory BTTVBadge.fromJson(Map<String, dynamic> json) =>
      _$BTTVBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$BTTVBadgeToJson(this);
}

@JsonSerializable()
class BTTVBadgeDetails {
  final String description;
  final String svg;

  BTTVBadgeDetails({
    required this.description,
    required this.svg,
  });

  factory BTTVBadgeDetails.fromJson(Map<String, dynamic> json) =>
      _$BTTVBadgeDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BTTVBadgeDetailsToJson(this);
}
