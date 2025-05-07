import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';

class Onboarding1Identity extends ConsumerStatefulWidget {
  const Onboarding1Identity({super.key});

  @override
  ConsumerState<Onboarding1Identity> createState() =>
      _Onboarding1IdentityState();
}

class _Onboarding1IdentityState extends ConsumerState<Onboarding1Identity> {
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

  void nextPage() {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }
    _formKey.currentState!.save();
    ref.read(onboardingNotifierProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 64,
            width: double.infinity,
            child: ColoredBox(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  "Let's talk details.",
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: _emailTextController,
                  onSaved: (email) => onboardingNotifier.updateEmail(email!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
                    prefixIcon: const Icon(Icons.email_rounded),
                    labelText: "Email*",
                    borderColor: colorScheme.primary,
                    borderRadius: 16,
                  ),
                ),
                TextFormField(
                  controller: _usernameTextController,
                  onSaved:
                      (username) =>
                          onboardingNotifier.updateUsername(username!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecorations.outlineBorder(
                    context: context,
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
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
                const Center(
                  child: Text(
                    "Username must be unique, have at 3-32 characters, and must only contain alphanumeric characters and or \".\"",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => nextPage(),
                      label: const Text("Next"),
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
