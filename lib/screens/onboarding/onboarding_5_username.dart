import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding5Username extends ConsumerStatefulWidget {
  const Onboarding5Username({super.key});

  @override
  ConsumerState<Onboarding5Username> createState() =>
      _Onboarding5UsernameState();
}

class _Onboarding5UsernameState extends ConsumerState<Onboarding5Username> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameTextController;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingNotifierProvider);

    _usernameTextController = TextEditingController(
      text: onboardingState.username,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameTextController.dispose();
  }

  void prevPage() {
    _formKey.currentState!.save();
    ref.read(onboardingNotifierProvider.notifier).prevPage();
  }

  Future<void> nextPage() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) return;

    _formKey.currentState!.save();
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);
    onboardingNotifier.startLoading();

    // Check if username already exists
    final result = await FirebaseFirestoreApi().getUserDocumentByUsername(
      _usernameTextController.text.trim(),
    );

    result.when(
      onSuccess: (success) {
        showDismissableSnackbar(
          context: context,
          message: "A user with that username already exists.",
        );
        onboardingNotifier.stopLoading();
        return;
      },
      onFailure: (failure) async {
        if (failure.error == FirestoreFailureError.networkError) {
          showDismissableSnackbar(context: context, message: failure.message);
          onboardingNotifier.stopLoading();
          return;
        }

        // Attempt to create Auth user
        final authResult = await onboardingNotifier.createAccount();
        if (mounted) {
          if (!authResult.success) {
            showDismissableSnackbar(
              context: context,
              message: authResult.message,
            );
            onboardingNotifier.stopLoading();
            onboardingNotifier.prevPage();
            return;
          }
        }

        // Attempt to create profile
        final profileCreated = await onboardingNotifier.createProfile();
        if (!profileCreated) {
          await FirebaseAuthApi().delete();
          if (mounted) {
            showDismissableSnackbar(
              context: context,
              message: "Profile cannot be created.",
            );
          }
          onboardingNotifier.stopLoading();
          return;
        }

        // Go to next page and complete the onboarding
        onboardingNotifier.nextPage();
        onboardingNotifier.stopLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "Excited to travel?",
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Let's set up your account."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            "Pick a unique handle.",
            style: textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _usernameTextController,
                      onSaved:
                          (username) =>
                              onboardingNotifier.updateUsername(username!),
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.alternate_email_rounded),
                        labelText: "Username*",
                        borderColor: colorScheme.primary,
                        borderRadius: 16,
                      ),
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a username",
                        ),
                        FormBuilderValidators.username(
                          allowDots: true,
                          errorText: "Please enter valid username",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        "Username must have 3-32 characters, and must only contain alphanumeric characters and or \".\"",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        onboardingState.isLoading ? null : () => prevPage(),
                    label: const Text("Go back"),
                    icon: const Icon(Symbols.arrow_back_rounded),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        onboardingState.isLoading
                            ? null
                            : () async => await nextPage(),
                    label: const Text("Next"),
                    icon: const Icon(Symbols.arrow_forward_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
