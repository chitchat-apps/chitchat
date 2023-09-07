import "package:chitchat/stores/settings_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class SettingsChatScreen extends StatefulWidget {
  const SettingsChatScreen({super.key});

  @override
  State<SettingsChatScreen> createState() => _SettingsChatScreenState();
}

class _SettingsChatScreenState extends State<SettingsChatScreen> {
  late var fontSize = context.read<SettingsStore>().fontSize;
  late var emoteScale = context.read<SettingsStore>().emoteScale;

  @override
  Widget build(BuildContext context) {
    var settingsStore = context.watch<SettingsStore>();

    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Chat"),
            leading: IconButton(
              tooltip: "Back",
              icon: Icon(Icons.adaptive.arrow_back_rounded, size: 20),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 5),
                child: Text(
                  "Sizing",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Font size"),
                        const Spacer(),
                        Text("${settingsStore.fontSize.toInt()}"),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape: CustomSliderTrackShape(),
                      ),
                      child: Slider(
                        value: fontSize,
                        min: 5,
                        max: 35,
                        label: fontSize.toInt().toString(),
                        divisions: 30,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                        onChangeEnd: (value) {
                          settingsStore.fontSize = value;
                        },
                      ),
                    ),
                    Text(
                      "Default: ${SettingsStore.defaultFontSize.toInt()}",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Emote scale"),
                        const Spacer(),
                        Text("${settingsStore.emoteScale}x"),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape: CustomSliderTrackShape(),
                      ),
                      child: Slider(
                        value: emoteScale,
                        min: 0.5,
                        max: 2,
                        label: "${emoteScale}x",
                        divisions: 6,
                        onChanged: (value) {
                          setState(() {
                            emoteScale = value;
                          });
                        },
                        onChangeEnd: (value) {
                          settingsStore.emoteScale = value;
                        },
                      ),
                    ),
                    Text(
                      "Default: ${SettingsStore.defaultEmoteScale}x",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 5),
                child: Text(
                  "Appearance",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text("Readable name colors"),
                subtitle: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adjusts the username to make it more readable.",
                    ),
                    Text(
                      "Default: ${SettingsStore.defaultReadableColors ? "on" : "off"}",
                    ),
                  ],
                ),
                value: settingsStore.readableColors,
                onChanged: (value) {
                  settingsStore.readableColors = value;
                },
              ),
              SwitchListTile(
                title: const Text("Message dividers"),
                subtitle: Text(
                  "Default: ${SettingsStore.defaultMessageDividers ? "on" : "off"}",
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 14,
                  ),
                ),
                value: settingsStore.messageDividers,
                onChanged: (value) {
                  settingsStore.messageDividers = value;
                },
              ),
              SwitchListTile(
                title: const Text("Show deleted messages"),
                subtitle: const Text(
                  "Default: ${SettingsStore.defaultShowDeleted ? "on" : "off"}",
                ),
                value: settingsStore.showDeleted,
                onChanged: (value) {
                  settingsStore.showDeleted = value;
                },
              ),
              SwitchListTile(
                title: const Text("Show deleted message extras"),
                subtitle: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Show deleted message extras such as the timeout duration, banned etc.",
                    ),
                    Text(
                      "Default: ${SettingsStore.defaultShowDeletedExtras ? "on" : "off"}",
                    ),
                  ],
                ),
                value: settingsStore.showDeletedExtras,
                onChanged: (value) {
                  settingsStore.showDeletedExtras = value;
                },
              ),
              SwitchListTile(
                title: const Text("Show timestamps"),
                subtitle: const Text(
                  "Default: ${SettingsStore.defaultShowTimestamps ? "on" : "off"}",
                ),
                value: settingsStore.showTimestamps,
                onChanged: (value) {
                  settingsStore.showTimestamps = value;
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 5),
                child: Text(
                  "Miscellaneous",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Restore default settings",
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.restore, color: Colors.red.shade400),
                onTap: () {
                  settingsStore.resetChat();
                  setState(() {
                    fontSize = settingsStore.fontSize;
                    emoteScale = settingsStore.emoteScale;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
