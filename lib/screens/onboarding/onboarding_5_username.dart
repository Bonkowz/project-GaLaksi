import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:image_picker/image_picker.dart';
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
            "Show yourself to the world.",
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
                    _ProfilePicture(),
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

class _ProfilePicture extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends ConsumerState<_ProfilePicture> {
  bool imageRemoved = false;

  void _saveImageFromGallery() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => imageRemoved = false);
    ref.read(onboardingNotifierProvider.notifier).updateImage(imageFile);
  }

  void _saveImageFromCamera() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return;
    }
    setState(() => imageRemoved = false);
    ref.read(onboardingNotifierProvider.notifier).updateImage(imageFile);
  }

  void _removeImage() {
    ref.read(onboardingNotifierProvider.notifier).updateImage(null);
    setState(() => imageRemoved = true);
    showSnackbar(
      context: context,
      message: "Image removed",
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final newImage = onboardingState.image;

    final avatar = _selectAvatar(context, newImage);

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth / 2,
                    height: constraints.maxWidth / 2,
                    child: avatar,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _saveImageFromGallery,
                    label: const Text("Pick from gallery"),
                    icon: const Icon(Symbols.photo_rounded),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: _saveImageFromCamera,
                    label: const Text("Take a picture"),
                    icon: const Icon(Symbols.camera_alt_rounded),
                  ),
                  OutlinedButton.icon(
                    onPressed: _removeImage,
                    label: const Text("Remove"),
                    icon: const Icon(Symbols.delete_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectAvatar(BuildContext context, String? newImage) {
    final firstName = ref.watch(onboardingNotifierProvider).firstName;
    final image = ref.watch(onboardingNotifierProvider).image;

    if (imageRemoved) {
      return _buildInitialAvatar(context, firstName!);
    } else if (newImage == null || newImage == '') {
      return _buildInitialAvatar(context, firstName!);
    } else {
      return _buildImageAvatar(context, image!);
    }
  }

  Widget _buildImageAvatar(BuildContext context, String base64Image) {
    return CircleAvatar(
      radius: double.infinity,
      backgroundImage: MemoryImage(base64Decode(base64Image)),
    );
  }

  Widget _buildInitialAvatar(BuildContext context, String initial) {
    return CircleAvatar(
      radius: double.infinity,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child:
          initial.isEmpty
              ? const SizedBox.shrink()
              : Text(
                StringUtils.capitalize(initial[0]),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
    );
  }
}
