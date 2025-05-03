import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth_notifier.dart';
import 'package:galaksi/screens/auth/sign_in_page.dart';
import 'package:galaksi/screens/auth/sign_up_page.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: Durations.medium1,
          child: authState.isSignIn ? const SignInPage() : const SignUpPage(),
        ),
      ),
    );
  }
}
