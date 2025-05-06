import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/auth_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var passwordIsVisible = false;
  String? message;

  Future<void> submit() async {
    setState(() {
      message = null;
    });

    final formIsValid = formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.signUp(
      email: emailTextController.text.trim(),
      password: passwordTextController.text,
    );
    setState(() {
      message = result.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    return Center(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign up",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 12,
                children: [
                  TextFormField(
                    controller: emailTextController,
                    onTapOutside:
                        (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecorations.outlineBorder(
                      context: context,
                      prefixIcon: const Icon(Icons.email_rounded),
                      labelText: "Email*",
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter an email",
                      ),
                      FormBuilderValidators.email(
                        errorText: "Please enter a valid email",
                      ),
                    ]),
                  ),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: !passwordIsVisible,
                    onTapOutside:
                        (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecorations.outlineBorder(
                      context: context,
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed:
                              () => setState(() {
                                passwordIsVisible = !passwordIsVisible;
                              }),
                          icon:
                              passwordIsVisible
                                  ? const Icon(Icons.visibility_off_rounded)
                                  : const Icon(Icons.visibility_rounded),
                        ),
                      ),
                      labelText: "Password*",
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
                ],
              ),
            ),
            FilledButton(
              onPressed:
                  authState.isLoading ? null : () async => await submit(),
              child: const Text("Sign up"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                const Text("Already have an account?"),
                TextButton.icon(
                  onPressed: () {
                    authNotifier.switchPages();
                  },
                  label: const Text("Sign in"),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: Durations.medium1,
              child:
                  message == null
                      ? const SizedBox.shrink()
                      : Text(
                        message!,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
