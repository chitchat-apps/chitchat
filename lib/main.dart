import "dart:convert";
import "package:chitchat/api/bttv_api.dart";
import "package:chitchat/api/ffz_api.dart";
import "package:chitchat/api/seven_tv_api.dart";
import "package:chitchat/api/twitch_api.dart";
import "package:chitchat/screens/home/home_screen.dart";
import "package:chitchat/screens/onboarding/onboarding_screen.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:chitchat/stores/settings_store.dart";
import "package:chitchat/stores/tab_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:http/http.dart";
import "package:mobx/mobx.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the API client(s)
  final client = Client();
  final twitchApi = TwitchApi(client);
  final ffzApi = FFZApi(client);
  final bttvApi = BTTVApi(client);
  final sevenTvApi = SevenTvApi(client);

  final prefs = await SharedPreferences.getInstance();

  final onboarded = prefs.getBool("onboarded") ?? true;

  // initialize the stores

  final settingsStore = SettingsStore.fromJson(
    jsonDecode(prefs.getString("settings") ?? "{}"),
  );

  final tabsStore = TabStore.fromJson(
    jsonDecode(prefs.getString("tabs") ?? "{}"),
  );

  final authStore = AuthStore(twitchApi: twitchApi);
  await authStore.initialize();

  final channelStore = ChannelStore(
    auth: authStore,
    twitchApi: twitchApi,
    ffzApi: ffzApi,
    bttvApi: bttvApi,
    sevenTvApi: sevenTvApi,
  );

  autorun((_) => prefs.setString("settings", jsonEncode(settingsStore)));
  autorun((_) => prefs.setString("tabs", jsonEncode(tabsStore)));

  runApp(
    MultiProvider(
      providers: [
        Provider<SettingsStore>(create: (_) => settingsStore),
        Provider<TabStore>(create: (_) => tabsStore),
        Provider<AuthStore>(create: (_) => authStore),
        Provider<ChannelStore>(create: (_) => channelStore),
        Provider<TwitchApi>(create: (_) => twitchApi),
        Provider<FFZApi>(create: (_) => ffzApi),
        Provider<BTTVApi>(create: (_) => bttvApi),
        Provider<SevenTvApi>(create: (_) => sevenTvApi),
      ],
      child: MyApp(showOnboarding: !onboarded),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool showOnboarding;

  const MyApp({super.key, this.showOnboarding = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final channelStore = context.read<ChannelStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    channelStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final authStore = context.read<AuthStore>();
        final settingsStore = context.read<SettingsStore>();

        return MaterialApp(
          title: "ChitChat",
          color: const Color.fromRGBO(92, 124, 250, 1),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(92, 124, 250, 1),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(92, 124, 250, 1),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: settingsStore.themeMode,
          debugShowCheckedModeBanner: false,
          home: widget.showOnboarding || !authStore.isAuthenticated
              ? const OnboardingScreen()
              : const HomeScreen(),
        );
      },
    );
  }
}
