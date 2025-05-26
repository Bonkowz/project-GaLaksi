import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/travel_activity/add_accommodation_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/place_autocomplete.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddAccommodationPage extends ConsumerStatefulWidget {
  const AddAccommodationPage({required this.travelPlanId, super.key});

  final String travelPlanId;

  @override
  ConsumerState<AddAccommodationPage> createState() =>
      _AddAccommodationPageState();
}

class _AddAccommodationPageState extends ConsumerState<AddAccommodationPage> {
  final _formKey = GlobalKey<FormState>();
  final accommodationController = TextEditingController();
  final startLocationController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  bool _isLoading = false;

  Future<void> submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final createAddAccommodationNotifier = ref.read(
      createAddAccommodationNotifierProvider.notifier,
    );

    createAddAccommodationNotifier.updateName(accommodationController.text);
    createAddAccommodationNotifier.updateCheckIn(startDate!, startTime!);
    createAddAccommodationNotifier.updateCheckOut(endDate!, endTime!);
    createAddAccommodationNotifier.updateLocation(placeSelected!);

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

    final result = await createAddAccommodationNotifier.addAccommodation(
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
              "You are offline. This accommodation is currently pending. "
              "Please connect to the internet before quitting the app to "
              "successfully create this activity.",
          duration: const Duration(minutes: 1),
        );
      }
    } else {
      if (mounted) {
        showDismissableSnackbar(
          context: context,
          message: "Accommodation created!",
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
    accommodationController.dispose();
    startLocationController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? placeSelected;

  /// Utility function for FormField
  String dateToString(DateTime date) {
    return "${DateFormat('MMMM').format(DateTime(0, date.month))} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  /// Utility function for FormField
  String timeToString(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }

  // TODO: make this return the code of the area
  String placeToString(Place place) {
    return place.displayName;
  }

  final reminders = ["5 minutes before", "10 minutes before", "1 hour before"];

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(createAddAccommodationNotifierProvider.notifier);
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
        title: Text("Add a new accommodation", style: textTheme.bodyLarge),
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
                      controller: accommodationController,
                      onTapOutside:
                          (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.title),
                        hintText: "Name of place",
                        borderRadius: 16,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Please enter a title",
                        ),
                      ]),
                    ),
                    PlaceAutocomplete(
                      onPlaceSelected: (place) {
                        setState(() {
                          placeSelected = placeToString(place);
                        });
                      },
                      controller: startLocationController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: startTimeController,
                            onTapOutside:
                                (event) =>
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus(),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                              );

                              if (pickedDate != null) {
                                startDate = pickedDate;

                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      startTime ??
                                      const TimeOfDay(
                                        hour: 14,
                                        minute: 0,
                                      ), // 2 PM default
                                );

                                if (pickedTime != null) {
                                  startTime = pickedTime;

                                  setState(() {
                                    startTimeController.text =
                                        '${dateToString(startDate!)} at ${timeToString(startTime!)}';
                                  });
                                }
                              }
                            },
                            decoration: InputDecorations.outlineBorder(
                              context: context,
                              prefixIcon: const Icon(Symbols.calendar_today),
                              hintText: "Check-in",
                              borderRadius: 16,
                            ),
                            validator: FormBuilderValidators.required(
                              errorText: "Select check-in",
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: endTimeController,
                            onTapOutside:
                                (event) =>
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus(),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    endDate ??
                                    (startDate?.add(const Duration(days: 1)) ??
                                        DateTime.now()),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate != null) {
                                endDate = pickedDate;

                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      endTime ??
                                      const TimeOfDay(
                                        hour: 11,
                                        minute: 0,
                                      ), // 11 AM default
                                );

                                if (pickedTime != null) {
                                  endTime = pickedTime;

                                  setState(() {
                                    endTimeController.text =
                                        '${dateToString(endDate!)} at ${timeToString(endTime!)}';
                                  });
                                }
                              }
                            },
                            decoration: InputDecorations.outlineBorder(
                              context: context,
                              prefixIcon: const Icon(Symbols.calendar_today),
                              hintText: "Check-out",
                              borderRadius: 16,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: "Select check-out",
                              ),
                              (value) {
                                if (startDate != null &&
                                    endDate != null &&
                                    startTime != null &&
                                    endTime != null) {
                                  final checkIn = DateTime(
                                    startDate!.year,
                                    startDate!.month,
                                    startDate!.day,
                                    startTime!.hour,
                                    startTime!.minute,
                                  );
                                  final checkOut = DateTime(
                                    endDate!.year,
                                    endDate!.month,
                                    endDate!.day,
                                    endTime!.hour,
                                    endTime!.minute,
                                  );
                                  if (checkOut.isBefore(checkIn)) {
                                    return "Check-out must be after check-in";
                                  }
                                }
                                return null;
                              },
                            ]),
                          ),
                        ),
                      ],
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
