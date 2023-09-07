import "package:chitchat/screens/home/home_screen.dart";
import "package:chitchat/stores/auth_store.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();

    return Scaffold(
      body: Center(
        child: FilledButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
          ),
          child: const Text("Sign in with Twitch"),
          onPressed: () {
            authStore.signInWithTwitch().then((isAuthenticated) {
              if (isAuthenticated) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
              } else {
                debugPrint("Not signed in.");
              }
            });
          },
        ),
      ),
    );
  }
}
