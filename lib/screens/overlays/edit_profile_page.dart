import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/user_profile_form_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/interest_selection.dart';
import 'package:galaksi/widgets/travel_style_selection.dart';
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
  final interestSelection = <Interest>{};
  final travelStyleSelectionMap = <TravelStyle, bool>{};
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
    setState(() {
      _hasSaved = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userProfileFormNotifier = ref.read(
      userProfileFormNotifierProvider.notifier,
    );
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final uid = ref.read(authNotifierProvider).user!.uid;

    _formKey.currentState!.save();
    _saveInterests();
    _saveStyles();
    final result = await userProfileFormNotifier.updateProfile();

    if (!result) {
      setState(() {
        _hasSaved = false;
      });
      if (!mounted) {
        return;
      }
      showDismissableSnackbar(
        context: context,
        message:
            "You are offline. This change is currently pending. "
            "Please connect to the internet before quitting the app to "
            "succesfully update your profile.",
        duration: const Duration(minutes: 1),
      );
      return;
    }
    await authNotifier.fetchUserProfile(uid);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user!;
    _firstNameTextController = TextEditingController(text: user.firstName);
    _lastNameTextController = TextEditingController(text: user.lastName);
    interestSelection.addAll(user.interests ?? {});
    for (final style in TravelStyle.values) {
      travelStyleSelectionMap[style] =
          user.travelStyles?.contains(style) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileFormNotifier = ref.read(
      userProfileFormNotifierProvider.notifier,
    );
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update your profile"),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card.outlined(
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
                        onSaved:
                            (firstName) => userProfileFormNotifier
                                .updateFirstName(firstName!),
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
                            (lastName) => userProfileFormNotifier
                                .updateLastName(lastName!),
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
                      InterestSelection(selection: interestSelection),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
