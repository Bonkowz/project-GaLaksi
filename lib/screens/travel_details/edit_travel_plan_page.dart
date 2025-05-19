import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/travel_plan/edit_travel_plan_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditTravelPlanPage extends ConsumerStatefulWidget {
  const EditTravelPlanPage({super.key, required this.travelPlan});

  final TravelPlan travelPlan;

  @override
  ConsumerState<EditTravelPlanPage> createState() => EditTravelPlanPageState();
}

class EditTravelPlanPageState extends ConsumerState<EditTravelPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final descriptionScrollController = ScrollController();

  bool _isLoading = false;

  Future<void> submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final travelPlanNotifier = ref.read(
      editTravelPlanNotifierProvider.notifier,
    );

    travelPlanNotifier.setCurrentTravelPlan(widget.travelPlan);

    travelPlanNotifier.updateTitle(titleTextController.text);
    travelPlanNotifier.updateDescription(descriptionTextController.text);

    final result = await travelPlanNotifier.editTravelPlan();

    setState(() {
      _isLoading = false;
    });

    if (!result) {
      if (mounted) {
        showDismissableSnackbar(
          context: context,
          message:
              "You are offline. This travel plan is currently pending. "
              "Please connect to the internet before quitting the app to "
              "succesfully create this travel plan.",
          duration: const Duration(minutes: 1),
        );
      }
    } else {
      if (mounted) {
        showDismissableSnackbar(context: context, message: "Changes saved!");
      }
      // Pop after the success message
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    titleTextController.text = widget.travelPlan.title;
    descriptionTextController.text = widget.travelPlan.description;
  }

  @override
  void dispose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    descriptionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Edit travel plan", style: textTheme.bodyLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: titleTextController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.title),
                        hintText: "Trip Title",
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a title",
                        ),
                        FormBuilderValidators.maxLength(
                          15,
                          errorText: "Title must be less than 15 characters.",
                        ),
                      ]),
                    ),
                    TextFormField(
                      scrollController: descriptionScrollController,
                      controller: descriptionTextController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        hintText: "Additional details about your trip...",
                        borderColor: Theme.of(context).colorScheme.primary,
                        contentPadding: const EdgeInsets.all(16.0),
                        borderRadius: 16,
                      ),
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
