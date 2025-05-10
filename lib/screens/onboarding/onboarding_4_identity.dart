import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding4Identity extends ConsumerStatefulWidget {
  const Onboarding4Identity({super.key});

  @override
  ConsumerState<Onboarding4Identity> createState() =>
      _Onboarding4IdentityState();
}

class _Onboarding4IdentityState extends ConsumerState<Onboarding4Identity> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailTextController;
  late final TextEditingController _usernameTextController;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingNotifierProvider);
    _emailTextController = TextEditingController(text: onboardingState.email);
    _usernameTextController = TextEditingController(
      text: onboardingState.username,
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  void prevPage() async {
    ref.read(onboardingNotifierProvider.notifier).prevPage();
  }

  Future<void> nextPage() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);

    onboardingNotifier.startLoading();
    final usernameExists = await FirebaseFirestoreApi()
        .getUserDocumentByUsername(_usernameTextController.text);

    if (mounted) {
      if (usernameExists != null) {
        showDismissableSnackbar(
          context: context,
          message: "A user with that username already exists.",
        );
        onboardingNotifier.stopLoading();
        return;
      }
    }

    onboardingNotifier.stopLoading();
    _formKey.currentState!.save();
    onboardingNotifier.nextPage();
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
            "Let's talk details.",
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
                      controller: _emailTextController,
                      onSaved:
                          (email) => onboardingNotifier.updateEmail(email!),
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter an email",
                        ),
                        FormBuilderValidators.email(
                          errorText: "Please enter a valid email",
                        ),
                      ]),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.email_rounded),
                        labelText: "Email*",
                        borderColor: colorScheme.primary,
                        borderRadius: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        "Username must be unique, have at 3-32 characters, and must only contain alphanumeric characters and or \".\"",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed:
                      onboardingState.isLoading
                          ? null
                          : () async => await nextPage(),
                  label: const Text("Next"),
                  icon: const Icon(Symbols.arrow_forward_rounded),
                ),
                OutlinedButton.icon(
                  onPressed:
                      onboardingState.isLoading ? null : () => prevPage(),
                  label: const Text("Go back"),
                  icon: const Icon(Symbols.arrow_back_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
