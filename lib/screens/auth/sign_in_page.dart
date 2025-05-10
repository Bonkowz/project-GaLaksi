import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var passwordIsVisible = false;

  Future<void> submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final result = await authNotifier.signInWithUsername(
      username: usernameTextController.text.trim(),
      password: passwordTextController.text,
    );
    if (mounted) {
      showDismissableSnackbar(context: context, message: result.message);
    }
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          "Welcome back!",
          style: textTheme.headlineMedium!.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    TextFormField(
                      controller: usernameTextController,
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
                    TextFormField(
                      controller: passwordTextController,
                      obscureText: !passwordIsVisible,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.password_rounded),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _showPasswordButton(),
                        ),
                        labelText: "Password*",
                        borderColor: colorScheme.primary,
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Please enter your password",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed:
                  authState.isLoading ? null : () async => await submit(),
              child: const Text("Sign in"),
            ),
            const SizedBox(height: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton.icon(
                  onPressed: () {
                    authNotifier.switchPages();
                  },
                  label: const Text("Create an account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton _showPasswordButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed:
          () => setState(() {
            passwordIsVisible = !passwordIsVisible;
          }),
      icon:
          passwordIsVisible
              ? Icon(Symbols.visibility_off_rounded, color: colorScheme.outline)
              : Icon(Symbols.visibility_rounded, color: colorScheme.outline),
    );
  }
}
