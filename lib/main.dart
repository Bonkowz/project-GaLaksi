import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth_notifier.dart';
import 'package:galaksi/screens/auth/auth_screen.dart';
import 'package:galaksi/screens/auth/sign_out_page.dart';
import 'package:galaksi/theme/theme.dart';
import 'package:galaksi/theme/util.dart';
import './firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStreamProvider);
    return MaterialApp(
      theme:
          GalaksiTheme(createTextTheme(context, "Figtree", "Figtree")).light(),
      darkTheme:
          GalaksiTheme(createTextTheme(context, "Figtree", "Figtree")).dark(),
      home: AnimatedSwitcher(
        duration: Durations.medium1,
        child: user.when(
          data:
              (user) =>
                  user == null
                      ? const AuthScreen(key: ValueKey("AuthScreen"))
                      : const SignOutPage(key: ValueKey("SignOutPage")),
          error:
              (error, stackTrace) =>
                  const Scaffold(body: Text("Error fetching user!")),
          loading: () => const Scaffold(body: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
