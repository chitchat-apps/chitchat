import "package:chitchat/screens/home/home_screen.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final authStore = context.read<AuthStore>();

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to ChitChat!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "To get started, you need to first authorize ChitChat to access your Twitch account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
                child: const Text("Sign in with Twitch"),
                onPressed: () {
                  authStore.signInWithTwitch().then((isAuthenticated) {
                    if (isAuthenticated) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool("onboarded", true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      });
                    } else {
                      debugPrint("Not signed in.");
                    }
                  });
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
