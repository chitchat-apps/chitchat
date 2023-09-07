// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsStore _$SettingsStoreFromJson(Map<String, dynamic> json) =>
    SettingsStore()
      ..themeMode =
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
              ThemeMode.system
      ..fontSize = (json['fontSize'] as num?)?.toDouble() ?? 14.0
      ..emoteScale = (json['emoteScale'] as num?)?.toDouble() ?? 1.0
      ..readableColors = json['readableColors'] as bool? ?? true
      ..messageDividers = json['messageDividers'] as bool? ?? false
      ..showDeleted = json['showDeleted'] as bool? ?? false
      ..showDeletedExtras = json['showDeletedExtras'] as bool? ?? true
      ..showTimestamps = json['showTimestamps'] as bool? ?? false;

Map<String, dynamic> _$SettingsStoreToJson(SettingsStore instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'fontSize': instance.fontSize,
      'emoteScale': instance.emoteScale,
      'readableColors': instance.readableColors,
      'messageDividers': instance.messageDividers,
      'showDeleted': instance.showDeleted,
      'showDeletedExtras': instance.showDeletedExtras,
      'showTimestamps': instance.showTimestamps,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStore, Store {
  late final _$themeModeAtom =
      Atom(name: '_SettingsStore.themeMode', context: context);

  @override
  ThemeMode get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(ThemeMode value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  late final _$fontSizeAtom =
      Atom(name: '_SettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$emoteScaleAtom =
      Atom(name: '_SettingsStore.emoteScale', context: context);

  @override
  double get emoteScale {
    _$emoteScaleAtom.reportRead();
    return super.emoteScale;
  }

  @override
  set emoteScale(double value) {
    _$emoteScaleAtom.reportWrite(value, super.emoteScale, () {
      super.emoteScale = value;
    });
  }

  late final _$readableColorsAtom =
      Atom(name: '_SettingsStore.readableColors', context: context);

  @override
  bool get readableColors {
    _$readableColorsAtom.reportRead();
    return super.readableColors;
  }

  @override
  set readableColors(bool value) {
    _$readableColorsAtom.reportWrite(value, super.readableColors, () {
      super.readableColors = value;
    });
  }

  late final _$messageDividersAtom =
      Atom(name: '_SettingsStore.messageDividers', context: context);

  @override
  bool get messageDividers {
    _$messageDividersAtom.reportRead();
    return super.messageDividers;
  }

  @override
  set messageDividers(bool value) {
    _$messageDividersAtom.reportWrite(value, super.messageDividers, () {
      super.messageDividers = value;
    });
  }

  late final _$showDeletedAtom =
      Atom(name: '_SettingsStore.showDeleted', context: context);

  @override
  bool get showDeleted {
    _$showDeletedAtom.reportRead();
    return super.showDeleted;
  }

  @override
  set showDeleted(bool value) {
    _$showDeletedAtom.reportWrite(value, super.showDeleted, () {
      super.showDeleted = value;
    });
  }

  late final _$showDeletedExtrasAtom =
      Atom(name: '_SettingsStore.showDeletedExtras', context: context);

  @override
  bool get showDeletedExtras {
    _$showDeletedExtrasAtom.reportRead();
    return super.showDeletedExtras;
  }

  @override
  set showDeletedExtras(bool value) {
    _$showDeletedExtrasAtom.reportWrite(value, super.showDeletedExtras, () {
      super.showDeletedExtras = value;
    });
  }

  late final _$showTimestampsAtom =
      Atom(name: '_SettingsStore.showTimestamps', context: context);

  @override
  bool get showTimestamps {
    _$showTimestampsAtom.reportRead();
    return super.showTimestamps;
  }

  @override
  set showTimestamps(bool value) {
    _$showTimestampsAtom.reportWrite(value, super.showTimestamps, () {
      super.showTimestamps = value;
    });
  }

  late final _$_SettingsStoreActionController =
      ActionController(name: '_SettingsStore', context: context);

  @override
  void toggleTheme() {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.toggleTheme');
    try {
      return super.toggleTheme();
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetChat() {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.resetChat');
    try {
      return super.resetChat();
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.reset');
    try {
      return super.reset();
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
themeMode: ${themeMode},
fontSize: ${fontSize},
emoteScale: ${emoteScale},
readableColors: ${readableColors},
messageDividers: ${messageDividers},
showDeleted: ${showDeleted},
showDeletedExtras: ${showDeletedExtras},
showTimestamps: ${showTimestamps}
    ''';
  }
}
