import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/user_profile_form_notifier.dart';
import 'package:galaksi/utils/dialog.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/interest_selection.dart';
import 'package:galaksi/widgets/travel_style_selection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameTextController;
  late final TextEditingController _lastNameTextController;
  late final TextEditingController _biographyTextController;
  late final TextEditingController _phoneNumberTextController;
  final interestSelection = <Interest>{};
  final travelStyleSelectionMap = <TravelStyle, bool>{};
  bool isPrivate = false;
  bool _hasSaved = false;

  void _saveInterests() {
    ref
        .read(userProfileFormNotifierProvider.notifier)
        .updateInterests(interestSelection);
  }

  void _saveStyles() {
    final selectedStyles =
        travelStyleSelectionMap.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toSet();
    ref
        .read(userProfileFormNotifierProvider.notifier)
        .updateTravelStyles(selectedStyles);
  }

  Future<void> _saveProfile() async {
    setState(() => _hasSaved = true);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasSaved = false);
      return;
    }
    // Show loading dialog
    showLoadingDialog(context: context, message: "Saving profile...");

    // Update profile
    final formNotifier = ref.read(userProfileFormNotifierProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final uid = ref.read(authNotifierProvider).user!.uid;

    formNotifier.updateFirstName(_firstNameTextController.text.trim());
    formNotifier.updateLastName(_lastNameTextController.text.trim());
    formNotifier.updateBiography(_biographyTextController.text.trim());
    formNotifier.updatePhoneNumber(_phoneNumberTextController.text.trim());
    formNotifier.updatePrivacy(isPrivate);

    _saveInterests();
    _saveStyles();
    final result = await formNotifier.updateProfile();

    // Close loading dialog
    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();

    // Check if update was successful
    if (!result) {
      setState(() => _hasSaved = false);
      if (!mounted) return;
      showDismissableSnackbar(
        context: context,
        message:
            "You are offline. This change is currently pending. "
            "Please connect to the internet before quitting the app to "
            "successfully update your profile.",
        duration: const Duration(minutes: 1),
      );
      return;
    }

    // Fetch updated user profile
    await authNotifier.fetchUserProfile(uid);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _biographyTextController.dispose();
    _phoneNumberTextController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user!;
    _firstNameTextController = TextEditingController(text: user.firstName);
    _lastNameTextController = TextEditingController(text: user.lastName);
    _biographyTextController = TextEditingController(text: user.biography);
    _phoneNumberTextController = TextEditingController(text: user.phoneNumber);
    isPrivate = user.isPrivate;
    interestSelection.addAll(user.interests ?? {});
    for (final style in TravelStyle.values) {
      travelStyleSelectionMap[style] =
          user.travelStyles?.contains(style) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update your profile", style: textTheme.bodyLarge),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _ProfilePicture(),
                _Privacy(
                  isPrivate: isPrivate,
                  onChanged: (newValue) => setState(() => isPrivate = newValue),
                ),
                _Name(
                  firstNameTextController: _firstNameTextController,
                  lastNameTextController: _lastNameTextController,
                ),
                _Biography(biographyTextController: _biographyTextController),
                _PhoneNumber(
                  phoneNumberTextController: _phoneNumberTextController,
                ),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Interests",
                          style: textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InterestSelection(
                          selection: interestSelection,
                          onSelectionChanged: () => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Travel Styles",
                          style: textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TravelStyleSelection(
                          selectionMap: travelStyleSelectionMap,
                          onSelectionChanged: () => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _hasSaved ? null : () async => await _saveProfile(),
              label: const Text("Save"),
              icon: const Icon(Symbols.save_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    required TextEditingController firstNameTextController,
    required TextEditingController lastNameTextController,
  }) : _firstNameTextController = firstNameTextController,
       _lastNameTextController = lastNameTextController;

  final TextEditingController _firstNameTextController;
  final TextEditingController _lastNameTextController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameTextController,
              onTapOutside:
                  (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
              onTapOutside:
                  (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
    );
  }
}

class _Biography extends StatelessWidget {
  const _Biography({required TextEditingController biographyTextController})
    : _biographyTextController = biographyTextController;

  final TextEditingController _biographyTextController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biography",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _biographyTextController,
              onTapOutside:
                  (event) => FocusManager.instance.primaryFocus?.unfocus(),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecorations.outlineBorder(
                context: context,
                prefixIcon: const Icon(Symbols.abc_rounded),
                labelText: "Biography",
                borderColor: colorScheme.primary,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNumber extends StatelessWidget {
  const _PhoneNumber({required TextEditingController phoneNumberTextController})
    : _phoneNumberTextController = phoneNumberTextController;

  final TextEditingController _phoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Phone Number",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberTextController,
              onTapOutside:
                  (event) => FocusManager.instance.primaryFocus?.unfocus(),
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.outlineBorder(
                context: context,
                prefixIcon: const Icon(Symbols.phone_rounded),
                labelText: "Phone Number",
                borderColor: colorScheme.primary,
                borderRadius: 16,
              ),
              validator: FormBuilderValidators.phoneNumber(
                errorText: "Please enter a valid phone number.",
                checkNullOrEmpty: false,
              ),
            ),
          ],
        ),
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
  Widget? _cachedAvatar;
  String? _lastImageData;

  void _saveImageFromGallery() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    final imageSize = await imageFile.length();
    debugPrint("IMAGE SIZE: $imageSize bytes");
    setState(() => imageRemoved = false);
    ref.read(userProfileFormNotifierProvider.notifier).updateImage(imageFile);
  }

  void _saveImageFromCamera() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (imageFile == null) {
      return;
    }
    final imageSize = await imageFile.length();
    debugPrint("IMAGE SIZE: $imageSize bytes");
    setState(() => imageRemoved = false);
    ref.read(userProfileFormNotifierProvider.notifier).updateImage(imageFile);
  }

  void _removeImage() {
    ref.read(userProfileFormNotifierProvider.notifier).updateImage(null);
    setState(() => imageRemoved = true);
    showSnackbar(
      context: context,
      message: "Image removed",
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileFormState = ref.watch(userProfileFormNotifierProvider);
    final user = ref.watch(authNotifierProvider).user!;
    final newImage = userProfileFormState.image;
    final hasNewImage = newImage != null && newImage.isNotEmpty;
    final hasUserImage = user.image.isNotEmpty;
    final userInitial = user.firstName.isNotEmpty ? user.firstName[0] : '';

    String? imageData;
    if (imageRemoved || newImage == '' || (!hasNewImage && !hasUserImage)) {
      imageData = null;
    } else if (hasNewImage) {
      imageData = newImage;
    } else if (hasUserImage) {
      imageData = user.image;
    }

    if (_cachedAvatar == null || _lastImageData != imageData) {
      if (imageRemoved || newImage == '' || (!hasNewImage && !hasUserImage)) {
        _cachedAvatar = _buildInitialAvatar(context, userInitial);
      } else if (hasNewImage) {
        _cachedAvatar = _buildImageAvatar(context, newImage);
      } else if (hasUserImage) {
        _cachedAvatar = _buildImageAvatar(context, user.image);
      } else {
        _cachedAvatar = _buildInitialAvatar(context, userInitial);
      }
      _lastImageData = imageData;
    }

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profile Picture",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth / 2,
                    height: constraints.maxWidth / 2,
                    child: _cachedAvatar,
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
      child: Text(
        StringUtils.capitalize(initial),
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _Privacy extends StatefulWidget {
  const _Privacy({required this.isPrivate, required this.onChanged});

  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  @override
  State<_Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<_Privacy> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card.outlined(
              clipBehavior: Clip.hardEdge,
              child: SwitchListTile(
                title: const Text("Private Profile"),
                subtitle: const Text(
                  "Your public profile will not be visible to other people.",
                ),
                value: widget.isPrivate,
                onChanged: widget.onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
