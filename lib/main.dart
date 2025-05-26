import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/screens/auth/auth_screen.dart';
import 'package:galaksi/screens/base_page.dart';
import 'package:galaksi/services/notification_service.dart';
import 'package:galaksi/theme/theme.dart';
import 'package:galaksi/theme/util.dart';
import 'package:galaksi/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStreamProvider);

    final textTheme = createTextTheme(context, "Figtree", "Figtree");

    // Listen to changes in travel plan streams and sync notification
    ref.listen<AsyncValue<List<TravelPlan>>>(myTravelPlansStreamProvider, (
      prev,
      next,
    ) async {
      final prevPlans = prev?.valueOrNull ?? [];
      final nextPlans = next.valueOrNull ?? [];

      final notificationSyncService = ref.read(notificationSyncServiceProvider);
      await notificationSyncService.syncNotifications(
        previousPlans: prevPlans,
        nextPlans: nextPlans,
      );
    });

    ref.listen<AsyncValue<List<TravelPlan>>>(sharedTravelPlansStreamProvider, (
      prev,
      next,
    ) async {
      final prevPlans = prev?.valueOrNull ?? [];
      final nextPlans = next.valueOrNull ?? [];

      final notificationSyncService = ref.read(notificationSyncServiceProvider);
      await notificationSyncService.syncNotifications(
        previousPlans: prevPlans,
        nextPlans: nextPlans,
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: GalaksiTheme(textTheme).light(),
      darkTheme: GalaksiTheme(textTheme).dark(),
      home: AnimatedSwitcher(
        duration: Durations.medium1,
        child: user.when(
          data: (user) {
            return user == null
                ? const AuthScreen(key: ValueKey("AuthScreen"))
                : const BasePage(key: ValueKey("BasePage"));
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
