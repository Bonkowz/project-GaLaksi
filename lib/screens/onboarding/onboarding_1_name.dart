import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding1Name extends ConsumerStatefulWidget {
  const Onboarding1Name({super.key});

  @override
  ConsumerState<Onboarding1Name> createState() => _Onboarding1NameState();
}

class _Onboarding1NameState extends ConsumerState<Onboarding1Name> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameTextController;
  late final TextEditingController _lastNameTextController;
  bool passwordIsVisible = false;
  bool confirmPasswordIsVisible = false;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingNotifierProvider);
    _firstNameTextController = TextEditingController(
      text: onboardingState.firstName,
    );
    _lastNameTextController = TextEditingController(
      text: onboardingState.lastName,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
  }

  void prevPage() {
    _formKey.currentState!.save();
    ref.read(onboardingNotifierProvider.notifier).prevPage();
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
            "What's your name?",
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
                      controller: _firstNameTextController,
                      onSaved:
                          (firstName) =>
                              onboardingNotifier.updateFirstName(firstName!),
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.abc_rounded),
                        labelText: "First Name*",
                        borderColor: colorScheme.primary,
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Please enter your first name",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameTextController,
                      onSaved:
                          (lastName) =>
                              onboardingNotifier.updateLastName(lastName!),
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.abc_rounded),
                        labelText: "Last Name*",
                        borderColor: colorScheme.primary,
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Please enter your last name",
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
                  onPressed: () => nextPage(),
                  label: const Text("Next"),
                  icon: const Icon(Symbols.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
