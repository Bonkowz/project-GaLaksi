import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';

class Onboarding2Security extends ConsumerStatefulWidget {
  const Onboarding2Security({super.key});

  @override
  ConsumerState<Onboarding2Security> createState() =>
      _Onboarding2SecurityState();
}

class _Onboarding2SecurityState extends ConsumerState<Onboarding2Security> {
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
    if (!formIsValid) {
      return;
    }
    _formKey.currentState!.save();
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);
    onboardingNotifier.toggleIsLoading();
    final result = await onboardingNotifier.createAccount();
    onboardingNotifier.toggleIsLoading();
    if (result.success) {
      onboardingNotifier.nextPage();
    } else {
      if (mounted) {
        showSnackbar(
          context: context,
          message: result.message,
          actionLabel: "Dismiss",
          onActionPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        );
        onboardingNotifier.prevPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);
    final onboardingState = ref.watch(onboardingNotifierProvider);

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
                  "Secure your account.",
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: _passwordTextController,
                  onSaved:
                      (password) =>
                          onboardingNotifier.updatePassword(password!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !passwordIsVisible,
                  decoration: InputDecorations.outlineBorder(
                    context: context,
                    prefixIcon: const Icon(Icons.password_rounded),
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
                                  Icons.visibility_off_rounded,
                                  color: colorScheme.outline,
                                )
                                : Icon(
                                  Icons.visibility_rounded,
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
                      errorText: "Password must be at least 8 characters long",
                    ),
                  ]),
                ),
                TextFormField(
                  controller: _confirmTextController,
                  onSaved:
                      (confirmPassword) => onboardingNotifier
                          .updateConfirmPassword(confirmPassword!),
                  onTapOutside:
                      (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !confirmPasswordIsVisible,
                  decoration: InputDecorations.outlineBorder(
                    context: context,
                    prefixIcon: const Icon(Icons.password_rounded),
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
                                  Icons.visibility_off_rounded,
                                  color: colorScheme.outline,
                                )
                                : Icon(
                                  Icons.visibility_rounded,
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
                        if (confirmPassword != _passwordTextController.text) {
                          return "Passwords do not match";
                        }
                      }
                      return null;
                    },
                  ]),
                ),
                const Center(
                  child: Text(
                    "Password must have at 3-32 characters",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed:
                          onboardingState.isLoading ? null : () => prevPage(),
                      label: const Text("Back"),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed:
                          onboardingState.isLoading
                              ? null
                              : () async => await nextPage(),
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
