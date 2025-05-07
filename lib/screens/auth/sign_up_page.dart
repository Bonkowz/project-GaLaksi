import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/screens/onboarding/onboarding_screen.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          "Start your journey!",
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 64,
              children: [
                IconButton.filled(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    size: constraints.maxWidth * 0.6,
                  ),
                ),
                Column(
                  children: [
                    const Text("Already have an account?"),
                    TextButton.icon(
                      onPressed: () {
                        authNotifier.switchPages();
                      },
                      label: const Text("Sign in instead"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
