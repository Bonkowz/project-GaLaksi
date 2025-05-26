import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/providers/travel_activity/add_note_notifier.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';

// TODO: finish provider for note
// NOTE: name, time, content
class AddNotePage extends ConsumerStatefulWidget {
  const AddNotePage({required this.travelPlanId, super.key});
  final String travelPlanId;

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  bool _isLoading = false;

  Future<void> submit() async {
    final user = ref.read(authNotifierProvider).user;

    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final createAddNoteNotifier = ref.read(addNoteNotifierProvider.notifier);

    createAddNoteNotifier.updateAuthorID(user!.uid);
    createAddNoteNotifier.updateMessage(titleTextController.text);
    createAddNoteNotifier.updateCreatedAt(DateTime.now(), TimeOfDay.now());

    final travelPlan =
        ref.watch(travelPlanStreamProvider(widget.travelPlanId)).valueOrNull;
    if (travelPlan == null) {
      showDismissableSnackbar(
        context: context,
        message: "An unexpected error occurred.",
      );
      setState(() => _isLoading = false);
      return;
    }

    final result = await createAddNoteNotifier.addNote(
      travelPlanId: travelPlan.id,
    );

    setState(() {
      _isLoading = false;
    });

    if (!result) {
      if (mounted) {
        showDismissableSnackbar(
          context: context,
          message:
              "You are offline. This note is currently pending. "
              "Please connect to the internet before quitting the app to "
              "successfully create this note.",
          duration: const Duration(minutes: 1),
        );
      }
    } else {
      if (mounted) {
        showDismissableSnackbar(context: context, message: "Note Added!");
      }
      // Pop after the success message
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }

  /// Utility function for FormField
  String timeToString(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(addNoteNotifierProvider.notifier);

    debugPrint('notifier hash in parent: ${notifier.hashCode}');

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_isLoading,
        actionsPadding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () async => await submit(),
            icon:
                _isLoading
                    ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                    : const Icon(Symbols.check),
          ),
        ],
        title: Text("Add a new note", style: textTheme.bodyLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  spacing: 0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: titleTextController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.title),
                        hintText: "Note",
                        borderRadius: 16,
                      ).copyWith(
                        counterText: "${titleTextController.text.length}",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a title",
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
