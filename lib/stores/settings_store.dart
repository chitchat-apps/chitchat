import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:mobx/mobx.dart";

// Include generated file
part "settings_store.g.dart";

@JsonSerializable()
class SettingsStore extends _SettingsStore with _$SettingsStore {
  static const defaultThemeMode = _SettingsStore.defaultThemeMode;
  static const defaultFontSize = _SettingsStore.defaultFontSize;
  static const defaultEmoteScale = _SettingsStore.defaultEmoteScale;
  static const defaultReadableColors = _SettingsStore.defaultReadableColors;
  static const defaultMessageDividers = _SettingsStore.defaultMessageDividers;
  static const defaultShowDeleted = _SettingsStore.defaultShowDeleted;
  static const defaultShowDeletedExtras =
      _SettingsStore.defaultShowDeletedExtras;
  static const defaultShowTimestamps = _SettingsStore.defaultShowTimestamps;

  SettingsStore();

  factory SettingsStore.fromJson(Map<String, dynamic> json) {
    return _$SettingsStoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SettingsStoreToJson(this);
  }
}

abstract class _SettingsStore with Store {
  static const defaultThemeMode = ThemeMode.system;
  static const defaultFontSize = 14.0;
  static const defaultEmoteScale = 1.0;
  static const defaultReadableColors = true;
  static const defaultMessageDividers = false;
  static const defaultShowDeleted = false;
  static const defaultShowDeletedExtras = true;
  static const defaultShowTimestamps = false;

  @JsonKey(defaultValue: defaultThemeMode)
  @observable
  var themeMode = defaultThemeMode;

  @JsonKey(defaultValue: defaultFontSize)
  @observable
  var fontSize = defaultFontSize;

  @JsonKey(defaultValue: defaultEmoteScale)
  @observable
  var emoteScale = defaultEmoteScale;

  @JsonKey(defaultValue: defaultReadableColors)
  @observable
  var readableColors = defaultReadableColors;

  @JsonKey(defaultValue: defaultMessageDividers)
  @observable
  var messageDividers = defaultMessageDividers;

  @JsonKey(defaultValue: defaultShowDeleted)
  @observable
  var showDeleted = defaultShowDeleted;

  @JsonKey(defaultValue: defaultShowDeletedExtras)
  @observable
  var showDeletedExtras = defaultShowDeletedExtras;

  @JsonKey(defaultValue: defaultShowTimestamps)
  @observable
  var showTimestamps = defaultShowTimestamps;

  @action
  void toggleTheme() {
    themeMode = switch (themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  @action
  void resetChat() {
    fontSize = defaultFontSize;
    emoteScale = defaultEmoteScale;
    readableColors = defaultReadableColors;
    messageDividers = defaultMessageDividers;
    showDeleted = defaultShowDeleted;
  }

  @action
  void reset() {
    themeMode = defaultThemeMode;
    resetChat();
  }
}
