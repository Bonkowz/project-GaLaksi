import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth_notifier.dart';
import 'package:galaksi/screens/auth/auth_screen.dart';
import 'package:galaksi/screens/auth/sign_out_page.dart';
import 'package:galaksi/theme/theme.dart';
import 'package:galaksi/theme/util.dart';
import 'package:galaksi/firebase_options.dart';

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
    final textTheme = createTextTheme(context, "Figtree", "Figtree");

    return MaterialApp(
      theme: GalaksiTheme(textTheme).light(),
      darkTheme: GalaksiTheme(textTheme).dark(),
      home: AnimatedSwitcher(
        duration: Durations.medium1,
        child: user.when(
          data: (user) {
            return user == null
                ? const AuthScreen(key: ValueKey("AuthScreen"))
                : const SignOutPage(key: ValueKey("SignOutPage"));
          },
          error: (error, stackTrace) {
            return const Scaffold(body: Text("Error fetching user!"));
          },
          loading: () {
            return const Scaffold(body: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
