import "dart:math";

import "package:json_annotation/json_annotation.dart";
import "package:mobx/mobx.dart";

part "tab_store.g.dart";

@JsonSerializable()
class TabStore extends TabStoreBase with _$TabStore {
  TabStore();

  factory TabStore.fromJson(Map<String, dynamic> json) {
    return _$TabStoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TabStoreToJson(this);
  }
}

abstract class TabStoreBase with Store {
  static var defaultTabs = <String>[];
  static var defaultTabIndex = 0;

  @JsonKey(defaultValue: <String>[])
  @observable
  var tabs = defaultTabs;

  @JsonKey(defaultValue: 0)
  @observable
  var tabIndex = defaultTabIndex;

  @action
  void addTab({required String channelName}) {
    var channel = channelName.trim();
    var foundTabIndex =
        tabs.indexWhere((element) => element.toLowerCase() == channel);
    if (foundTabIndex != -1) {
      tabIndex = foundTabIndex;
      return;
    }

    tabs.add(channel);
    tabIndex = tabs.length - 1;
  }

  @action
  void removeTab({required String channelName}) {
    var channel = channelName.toLowerCase();
    var index = tabs.indexWhere((element) => element.toLowerCase() == channel);
    if (index == -1) {
      return;
    }

    tabs.removeAt(index);
    tabIndex = max(tabs.length - 1, 0);
  }

  @action
  void removeTabAt({required int index}) {
    tabs.removeAt(index);
    tabIndex = max(index - 1, 0);
  }

  @action
  void reorderTabs({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    tabs.insert(newIndex, tabs.removeAt(oldIndex));
  }

  @action
  void clearTabs() {
    tabs.clear();
    tabIndex = 0;
  }

  @action
  void reset() {
    tabs = defaultTabs;
    tabIndex = defaultTabIndex;
  }
}
