// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TabStore _$TabStoreFromJson(Map<String, dynamic> json) => TabStore()
  ..tabs =
      (json['tabs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? []
  ..tabIndex = json['tabIndex'] as int? ?? 0;

Map<String, dynamic> _$TabStoreToJson(TabStore instance) => <String, dynamic>{
      'tabs': instance.tabs,
      'tabIndex': instance.tabIndex,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TabStore on TabStoreBase, Store {
  late final _$tabsAtom = Atom(name: 'TabStoreBase.tabs', context: context);

  @override
  List<String> get tabs {
    _$tabsAtom.reportRead();
    return super.tabs;
  }

  @override
  set tabs(List<String> value) {
    _$tabsAtom.reportWrite(value, super.tabs, () {
      super.tabs = value;
    });
  }

  late final _$tabIndexAtom =
      Atom(name: 'TabStoreBase.tabIndex', context: context);

  @override
  int get tabIndex {
    _$tabIndexAtom.reportRead();
    return super.tabIndex;
  }

  @override
  set tabIndex(int value) {
    _$tabIndexAtom.reportWrite(value, super.tabIndex, () {
      super.tabIndex = value;
    });
  }

  late final _$TabStoreBaseActionController =
      ActionController(name: 'TabStoreBase', context: context);

  @override
  void addTab({required String channelName}) {
    final _$actionInfo =
        _$TabStoreBaseActionController.startAction(name: 'TabStoreBase.addTab');
    try {
      return super.addTab(channelName: channelName);
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTab({required String channelName}) {
    final _$actionInfo = _$TabStoreBaseActionController.startAction(
        name: 'TabStoreBase.removeTab');
    try {
      return super.removeTab(channelName: channelName);
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTabAt({required int index}) {
    final _$actionInfo = _$TabStoreBaseActionController.startAction(
        name: 'TabStoreBase.removeTabAt');
    try {
      return super.removeTabAt(index: index);
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reorderTabs({required int oldIndex, required int newIndex}) {
    final _$actionInfo = _$TabStoreBaseActionController.startAction(
        name: 'TabStoreBase.reorderTabs');
    try {
      return super.reorderTabs(oldIndex: oldIndex, newIndex: newIndex);
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTabs() {
    final _$actionInfo = _$TabStoreBaseActionController.startAction(
        name: 'TabStoreBase.clearTabs');
    try {
      return super.clearTabs();
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo =
        _$TabStoreBaseActionController.startAction(name: 'TabStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$TabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tabs: ${tabs},
tabIndex: ${tabIndex}
    ''';
  }
}
