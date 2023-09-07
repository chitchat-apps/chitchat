import "package:chitchat/helpers/theme_mode_helpers.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class SettingsAppearanceScreen extends StatefulWidget {
  const SettingsAppearanceScreen({super.key});

  @override
  State<SettingsAppearanceScreen> createState() =>
      _SettingsAppearanceScreenState();
}

class _SettingsAppearanceScreenState extends State<SettingsAppearanceScreen> {
  ThemeMode groupValue = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final settingsStore = context.read<SettingsStore>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Appearance"),
            leading: IconButton(
              tooltip: "Back",
              icon: Icon(Icons.adaptive.arrow_back_rounded, size: 20),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          body: ListView(
            children: [
              RadioListTile(
                title:
                    Text(ThemeModeHelpers.getThemeModeName(ThemeMode.system)),
                value: ThemeMode.system,
                groupValue: settingsStore.themeMode,
                onChanged: (_) {
                  settingsStore.themeMode = ThemeMode.system;
                },
              ),
              RadioListTile(
                title: Text(ThemeModeHelpers.getThemeModeName(ThemeMode.light)),
                value: ThemeMode.light,
                groupValue: settingsStore.themeMode,
                onChanged: (_) {
                  settingsStore.themeMode = ThemeMode.light;
                },
              ),
              RadioListTile(
                title: Text(ThemeModeHelpers.getThemeModeName(ThemeMode.dark)),
                value: ThemeMode.dark,
                groupValue: settingsStore.themeMode,
                onChanged: (_) {
                  settingsStore.themeMode = ThemeMode.dark;
                },
              )
            ],
          ),
        );
      },
    );
  }
}
