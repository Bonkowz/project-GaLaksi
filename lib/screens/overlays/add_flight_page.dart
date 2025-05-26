import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/flight_detail_model.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/travel_activity/add_flight_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/place_autocomplete.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddFlightPage extends ConsumerStatefulWidget {
  const AddFlightPage({required this.travelPlanId, super.key});

  final String travelPlanId;

  @override
  ConsumerState<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends ConsumerState<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final flightCodeController = TextEditingController();
  final airlinesController = TextEditingController();
  final startLocationController = TextEditingController();
  final endLocationController = TextEditingController();
  final departureAtController = TextEditingController();
  final departureAtTimeController = TextEditingController();

  bool _isLoading = false;

  Future<void> submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final createAddFlightDetailNotifier = ref.read(
      createAddFlightDetailNotifierProvider.notifier,
    );

    createAddFlightDetailNotifier.updateFlightNumber(flightCodeController.text);
    createAddFlightDetailNotifier.updateAirline(airlinesController.text);
    createAddFlightDetailNotifier.updateLocation(origin!);
    createAddFlightDetailNotifier.updateDestination(destination!);
    createAddFlightDetailNotifier.updateDepartureAt(activityDate!, startTime!);

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

    final result = await createAddFlightDetailNotifier.addFlightDetail(
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
              "You are offline. This flight detail is currently pending. "
              "Please connect to the internet before quitting the app to "
              "succesfully create this activity.",
          duration: const Duration(minutes: 1),
        );
      }
    } else {
      if (mounted) {
        showDismissableSnackbar(
          context: context,
          message: "Flight detail created!",
        );
      }
      // Pop after the success message
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    flightCodeController.dispose();
    airlinesController.dispose();
    startLocationController.dispose();
    endLocationController.dispose();
    super.dispose();
  }

  DateTime? activityDate;
  TimeOfDay? startTime;
  String? origin;
  String? destination;

  /// Utility function for FormField
  String dateToString(DateTime date) {
    return "${DateFormat('MMMM').format(DateTime(0, date.month))} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  /// Utility function for FormField
  String timeToString(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }
  String placeToString(Place place) {
    return place.displayName.split(',').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(createAddFlightDetailNotifierProvider.notifier);
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
        title: Text("Add a new flight", style: textTheme.bodyLarge),
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4), 
                                child: Text(
                                  "Origin",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              PlaceAutocomplete(
                                onPlaceSelected: (place) {
                                  setState(() {
                                    origin = placeToString(place);
                                  });
                                },
                                controller: startLocationController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  "Destination",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              PlaceAutocomplete(
                                onPlaceSelected: (place) {
                                  setState(() {
                                    destination = placeToString(place);
                                  });
                                },
                                controller: endLocationController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      // NOTE: flight number
                      controller: flightCodeController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.title),
                        hintText: "Flight Code",
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a title",
                        ),
                      ]),
                    ),
                    TextFormField(
                      // NOTE: airlines
                      controller: airlinesController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.title),
                        hintText: "Airlines",
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a title",
                        ),
                      ]),
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: departureAtController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: activityDate ?? DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2030),
                        );

                        if (pickedDate != null) {
                          activityDate = pickedDate;
                          
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: startTime ?? TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            startTime = pickedTime;
                            
                            setState(() {
                              departureAtController.text = 
                                  '${dateToString(activityDate!)} at ${timeToString(startTime!)}';
                            });
                          }
                        }
                      },
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.calendar_today),
                        hintText: "Select date and time",
                        borderRadius: 16,
                      ),

                      validator: FormBuilderValidators.required(
                        errorText: "Please enter a valid date and time",
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
