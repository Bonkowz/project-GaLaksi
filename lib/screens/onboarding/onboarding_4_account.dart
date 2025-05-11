import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/utils/string_utils.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding4Account extends ConsumerStatefulWidget {
  const Onboarding4Account({super.key});

  @override
  ConsumerState<Onboarding4Account> createState() => _Onboarding4AccountState();
}

class _Onboarding4AccountState extends ConsumerState<Onboarding4Account> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;
  late final TextEditingController _confirmTextController;
  bool passwordIsVisible = false;
  bool confirmPasswordIsVisible = false;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingNotifierProvider);
    _emailTextController = TextEditingController(text: onboardingState.email);
    _passwordTextController = TextEditingController(
      text: onboardingState.password,
    );
    _confirmTextController = TextEditingController(
      text: onboardingState.confirmPassword,
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmTextController.dispose();
    super.dispose();
  }

  void prevPage() async {
    _formKey.currentState!.save();
    ref.read(onboardingNotifierProvider.notifier).prevPage();
  }

  Future<void> nextPage() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    // Update onboarding state
    _formKey.currentState!.save();

    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);
    onboardingNotifier.startLoading();

    // Retrieve email from onboarding state, normalized and alias kept
    final email = ref.read(onboardingNotifierProvider).email;

    // Check if matching email already exists in Firestore
    final emailExists = await FirebaseFirestoreApi()
        .getUserDocumentByCanonicalEmail(StringUtils.normalizeEmail(email!));

    if (mounted) {
      if (emailExists != null) {
        showDismissableSnackbar(
          context: context,
          message: "A user with that email already exists.",
        );
        onboardingNotifier.stopLoading();
        return;
      }
    }

    onboardingNotifier.stopLoading();

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
            "Create your account.",
            style: textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        controller: _passwordTextController,
                        onSaved:
                            (password) =>
                                onboardingNotifier.updatePassword(password!),
                        onTapOutside:
                            (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !passwordIsVisible,
                        decoration: InputDecorations.outlineBorder(
                          context: context,
                          prefixIcon: const Icon(Symbols.password_rounded),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed:
                                  () => setState(() {
                                    passwordIsVisible = !passwordIsVisible;
                                  }),
                              icon:
                                  passwordIsVisible
                                      ? Icon(
                                        Symbols.visibility_off_rounded,
                                        color: colorScheme.outline,
                                      )
                                      : Icon(
                                        Symbols.visibility_rounded,
                                        color: colorScheme.outline,
                                      ),
                            ),
                          ),
                          labelText: "Password*",
                          borderColor: colorScheme.primary,
                          borderRadius: 16,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Please enter a password",
                          ),
                          FormBuilderValidators.password(
                            minLength: 8,
                            minLowercaseCount: 0,
                            minNumberCount: 0,
                            minUppercaseCount: 0,
                            minSpecialCharCount: 0,
                            errorText:
                                "Password must be at least 8 characters long",
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmTextController,
                        onSaved:
                            (confirmPassword) => onboardingNotifier
                                .updateConfirmPassword(confirmPassword!),
                        onTapOutside:
                            (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !confirmPasswordIsVisible,
                        decoration: InputDecorations.outlineBorder(
                          context: context,
                          prefixIcon: const Icon(Symbols.password_rounded),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed:
                                  () => setState(() {
                                    confirmPasswordIsVisible =
                                        !confirmPasswordIsVisible;
                                  }),
                              icon:
                                  confirmPasswordIsVisible
                                      ? Icon(
                                        Symbols.visibility_off_rounded,
                                        color: colorScheme.outline,
                                      )
                                      : Icon(
                                        Symbols.visibility_rounded,
                                        color: colorScheme.outline,
                                      ),
                            ),
                          ),
                          labelText: "Confirm Password*",
                          borderColor: colorScheme.primary,
                          borderRadius: 16,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Please reenter your password",
                          ),
                          (confirmPassword) {
                            if (confirmPassword != null) {
                              if (confirmPassword !=
                                  _passwordTextController.text) {
                                return "Passwords do not match";
                              }
                            }
                            return null;
                          },
                        ]),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          "Password must have 8-32 characters",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
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
