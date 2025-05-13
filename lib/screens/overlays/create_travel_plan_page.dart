import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateTravelPlanPage extends ConsumerStatefulWidget {
  const CreateTravelPlanPage({super.key});

  @override
  ConsumerState<CreateTravelPlanPage> createState() =>
      _CreateTravelPlanPageState();
}

class _CreateTravelPlanPageState extends ConsumerState<CreateTravelPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
        title: Text("Create a travel plan", style: textTheme.bodyLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create from scratch",
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: titleTextController,
                    onTapOutside:
                        (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecorations.underlineBorder(
                      context: context,
                      prefixIcon: const Icon(Symbols.title),
                      hintText: "Title",
                      borderColor: Theme.of(context).colorScheme.primary,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter a title",
                      ),
                    ]),
                  ),
                  TextFormField(
                    controller: descriptionTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTapOutside:
                        (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecorations.outlineBorder(
                      context: context,
                      hintText: "Description",
                      borderColor: Theme.of(context).colorScheme.primary,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ],
              ),
            ),
            const Row(
              spacing: 16,
              children: [
                Expanded(child: Divider()),
                Text("or"),
                Expanded(child: Divider()),
              ],
            ),
            Text(
              "Join a friend's travel plan",
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Symbols.camera_alt_rounded),
                    iconSize: 48,
                    padding: EdgeInsets.all(24.0),
                  ),
                  Text(
                    "Ask your friend for their QR code!",
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
