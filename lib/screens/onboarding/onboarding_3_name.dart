import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';

class Onboarding3Name extends ConsumerStatefulWidget {
  const Onboarding3Name({super.key});

  @override
  ConsumerState<Onboarding3Name> createState() => _Onboarding3NameState();
}

class _Onboarding3NameState extends ConsumerState<Onboarding3Name> {
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
    showSnackbar(context: context, message: "Not yet implemented!");
    // if (!formIsValid) {
    //   return;
    // }
    // _formKey.currentState!.save();
    // ref.read(onboardingNotifierProvider.notifier).nextPage();
    // TODO: Implement the next page logic
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
                  "What's your name?",
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: _firstNameTextController,
                  onSaved:
                      (firstName) =>
                          onboardingNotifier.updateFirstName(firstName!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  keyboardType: TextInputType.name,
                  decoration: InputDecorations.outlineBorder(
                    context: context,
                    prefixIcon: const Icon(Icons.abc_rounded),

                    labelText: "First Name*",
                    borderColor: colorScheme.primary,
                    borderRadius: 16,
                  ),
                  validator: FormBuilderValidators.firstName(
                    errorText: "Please enter your first name",
                  ),
                ),
                TextFormField(
                  controller: _lastNameTextController,
                  onSaved:
                      (lastName) =>
                          onboardingNotifier.updateLastName(lastName!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  keyboardType: TextInputType.name,
                  decoration: InputDecorations.outlineBorder(
                    context: context,
                    prefixIcon: const Icon(Icons.abc_rounded),
                    labelText: "Last Name*",
                    borderColor: colorScheme.primary,
                    borderRadius: 16,
                  ),
                  validator: FormBuilderValidators.firstName(
                    errorText: "Please enter your last name",
                  ),
                ),

                Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => prevPage(),
                      label: const Text("Back"),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
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
