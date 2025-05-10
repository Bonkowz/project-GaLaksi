import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding5Security extends ConsumerStatefulWidget {
  const Onboarding5Security({super.key});

  @override
  ConsumerState<Onboarding5Security> createState() =>
      _Onboarding5SecurityState();
}

class _Onboarding5SecurityState extends ConsumerState<Onboarding5Security> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordTextController;
  late final TextEditingController _confirmTextController;
  bool passwordIsVisible = false;
  bool confirmPasswordIsVisible = false;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingNotifierProvider);
    _passwordTextController = TextEditingController(
      text: onboardingState.password,
    );
    _confirmTextController = TextEditingController(
      text: onboardingState.confirmPassword,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _confirmTextController.dispose();
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
    onboardingNotifier.toggleIsLoading();

    try {
      // Create Auth user
      final authResult = await onboardingNotifier.createAccount();
      onboardingNotifier.toggleIsLoading();
      if (mounted) {
        if (!authResult.success) {
          showSnackbar(
            context: context,
            message: authResult.message,
            actionLabel: "Dismiss",
            onActionPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          );
          onboardingNotifier.toggleIsLoading();
          onboardingNotifier.prevPage();
          return;
        }
      }

      // Create Firestore profile
      final profileCreated = await onboardingNotifier.createProfile();
      if (!profileCreated) {
        await FirebaseAuthApi().delete();
        if (mounted) {
          showSnackbar(
            context: context,
            message: "Profile cannot be created.",
            actionLabel: "Dismiss",
            onActionPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          );
        }
        onboardingNotifier.toggleIsLoading();
        return;
      }

      // Go to next page and complete the onboarding
      onboardingNotifier.nextPage();
      onboardingNotifier.toggleIsLoading();
    } catch (e) {
      if (mounted) {
        showSnackbar(
          context: context,
          message: "An unexpected error occurred.",
          actionLabel: "Dismiss",
          onActionPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        );
      }
    }
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
            "Secure your account.",
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
                        "Password must have at 8-32 characters",
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
