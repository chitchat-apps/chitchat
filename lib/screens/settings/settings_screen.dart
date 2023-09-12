import "package:chitchat/helpers/theme_mode_helpers.dart";
import "package:chitchat/screens/onboarding/onboarding_screen.dart";
import "package:chitchat/screens/settings/appearance/settings_appearance_screen.dart";
import "package:chitchat/screens/settings/chat/settings_chat_screen.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:chitchat/stores/tab_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void resetApp() {
    final tabStore = context.read<TabStore>();
    final channelStore = context.read<ChannelStore>();
    final settingsStore = context.read<SettingsStore>();
    final authStore = context.read<AuthStore>();

    tabStore.reset();
    settingsStore.reset();
    channelStore.reset().then((_) {
      authStore.signOut().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final settingsStore = context.read<SettingsStore>();
        final authStore = context.read<AuthStore>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
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
                  "General",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Row(
                  children: [
                    const Text("Appearance"),
                    const Spacer(),
                    Text(
                      ThemeModeHelpers.getThemeModeName(
                          settingsStore.themeMode),
                    ),
                  ],
                ),
                trailing: Icon(Icons.adaptive.arrow_forward, size: 14),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsAppearanceScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text("Chat"),
                trailing: Icon(Icons.adaptive.arrow_forward, size: 14),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsChatScreen(),
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 5),
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (authStore.userStore.user != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Signed in as",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authStore.userStore.user!.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          authStore.userStore.user!.profileImageUrl,
                          height: 32,
                          width: 32,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ListTile(
                title: const Text("Sign out"),
                leading: const Icon(Icons.logout),
                trailing: authStore.isAuthenticated
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green[400],
                      )
                    : Icon(
                        Icons.warning_rounded,
                        color: Colors.orange[400],
                      ),
                enabled: authStore.isAuthenticated,
                onTap: () {
                  authStore.signOut().then(
                        (_) => {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          )
                        },
                      );
                },
              ),
              if (!const bool.fromEnvironment("dart.vm.product"))
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 30, 16, 5),
                  child: Text(
                    "Danger zone",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!const bool.fromEnvironment("dart.vm.product"))
                ListTile(
                  leading: Icon(Icons.restore, color: Colors.red.shade400),
                  title: Row(
                    children: [
                      Text(
                        "Reset app",
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                  onTap: () async {
                    resetApp();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
