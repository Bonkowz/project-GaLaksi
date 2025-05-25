import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/travel_activity/create_travel_activity_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/place_autocomplete.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateTravelActivityPage extends ConsumerStatefulWidget {
  const CreateTravelActivityPage({required this.travelPlanId, super.key});

  final String travelPlanId;

  @override
  ConsumerState<CreateTravelActivityPage> createState() =>
      _CreateTravelActivityPageState();
}

class _CreateTravelActivityPageState
    extends ConsumerState<CreateTravelActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> dropdownKey = GlobalKey<FormFieldState>();
  final titleTextController = TextEditingController();
  final activityDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final locationFocusNode = FocusNode();

  bool _isLoading = false;

  Future<void> submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final createTravelActivityNotifier = ref.read(
      createTravelActivityNotifierProvider.notifier,
    );

    createTravelActivityNotifier.updateTitle(titleTextController.text);
    createTravelActivityNotifier.updateStartAt(activityDate!, startTime!);
    createTravelActivityNotifier.updateEndAt(activityDate!, endTime!);
    createTravelActivityNotifier.updateReminders(
      userReminders.map((r) => r.duration).toList(),
    );
    createTravelActivityNotifier.updateLocation(placeSelected!);

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

    final result = await createTravelActivityNotifier.addTravelActivity(
      travelPlanId: travelPlan.id,
    );

    setState(() {
      _isLoading = false;
    });

    if (result is FirestoreFailure) {
      if (mounted) {
        showDismissableSnackbar(
          context: context,
          message: result.message,
          duration: const Duration(seconds: 10),
        );
      }
    } else {
      if (mounted) {
        showDismissableSnackbar(context: context, message: "Activity created!");
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
    activityDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  DateTime? activityDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<Reminder> userReminders = [];
  Place? placeSelected;

  /// Utility function for FormField
  String dateToString(DateTime date) {
    return "${DateFormat('MMMM').format(DateTime(0, date.month))} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  /// Utility function for FormField
  String timeToString(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }

  final reminders = [
    Reminder(
      duration: const Duration(minutes: 10),
      message: "10 minutes before",
    ),
    Reminder(duration: const Duration(days: 1), message: "1 day before"),
    Reminder(duration: const Duration(days: 7), message: "1 week before"),
    Reminder(duration: const Duration(hours: 1), message: "1 hour before"),
  ];

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
        title: Text("Create a travel activity", style: textTheme.bodyLarge),
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
                    ValueListenableBuilder(
                      valueListenable: titleTextController,
                      builder: (context, value, _) {
                        return TextFormField(
                          controller: titleTextController,
                          onTapOutside:
                              (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecorations.outlineBorder(
                            context: context,
                            prefixIcon: const Icon(Symbols.title),
                            hintText: "Trip Title",
                            borderRadius: 16,
                          ).copyWith(counterText: "${value.text.length} / 30"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Please enter a title",
                            ),
                            FormBuilderValidators.maxLength(
                              20,
                              errorText:
                                  "Title must be less than 30 characters.",
                            ),
                          ]),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                        );
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: activityDateController,
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

                        activityDate = pickedDate;

                        if (pickedDate != null) {
                          setState(() {
                            activityDateController.text = dateToString(
                              activityDate!,
                            );
                          });

                          if (startTime == null && endTime == null) {
                            startTime = TimeOfDay.now();
                            endTime = TimeOfDay(
                              hour: TimeOfDay.now().hour + 1,
                              minute: TimeOfDay.now().minute,
                            );

                            setState(() {
                              startTimeController.text = timeToString(
                                startTime!,
                              );
                              endTimeController.text = timeToString(endTime!);
                            });
                          }
                        }
                      },
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: const Icon(Symbols.calendar_today),
                        hintText: "Start date",
                        borderRadius: 16,
                      ),

                      validator: FormBuilderValidators.required(
                        errorText: "Please enter a day",
                      ),
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            controller: startTimeController,
                            onTapOutside:
                                (event) =>
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus(),
                            onTap: () async {
                              final pickedStartTime = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(
                                  hour: 8,
                                  minute: 0,
                                ),
                              );

                              setState(() {
                                startTime = pickedStartTime;
                                startTimeController.text = timeToString(
                                  startTime!,
                                );

                                if (activityDate == null) {
                                  activityDate = DateTime.now();
                                  activityDateController.text = dateToString(
                                    activityDate!,
                                  );
                                }
                              });

                              if (endTime == null) {
                                endTime = TimeOfDay(
                                  hour: startTime!.hour + 1,
                                  minute: startTime!.minute,
                                );

                                setState(() {
                                  endTimeController.text = timeToString(
                                    endTime!,
                                  );
                                });
                              }
                            },

                            decoration: InputDecorations.outlineBorder(
                              context: context,
                              hintText: "Start time",
                              prefixIcon: const Icon(Symbols.alarm),
                              borderRadius: 16,
                            ),

                            validator: (value) {
                              if (startTime == null) {
                                return "Enter a time."; // can't validate yet
                              }

                              if (startTime!.compareTo(endTime!) >= 0) {
                                return "Invalid time.";
                              }

                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            controller: endTimeController,
                            onTapOutside:
                                (event) =>
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus(),
                            onTap: () async {
                              final pickedEndTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    startTime ??
                                    const TimeOfDay(hour: 8, minute: 0),
                              );

                              setState(() {
                                endTime = pickedEndTime;
                                endTimeController.text = timeToString(endTime!);
                              });

                              if (activityDate == null) {
                                setState(() {
                                  activityDate = DateTime.now();
                                  activityDateController.text = dateToString(
                                    activityDate!,
                                  );
                                });
                              }
                            },
                            decoration: InputDecorations.outlineBorder(
                              context: context,
                              hintText: "End time",
                              prefixIcon: const Icon(Symbols.alarm),
                              borderRadius: 16,
                            ),

                            validator: (value) {
                              if (endTime == null) {
                                return 'Enter a time.'; // can't validate yet
                              }

                              if (startTime!.compareTo(endTime!) >= 0) {
                                return "Invalid time!";
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    PlaceAutocomplete(
                      onPlaceSelected: (place) {
                        setState(() {
                          placeSelected = place;
                        });
                      },
                      controller: locationController,
                    ),

                    ImplicitlyAnimatedList<Reminder>(
                      insertDuration: const Duration(milliseconds: 200),
                      removeDuration: const Duration(milliseconds: 200),
                      shrinkWrap: true,
                      items: userReminders,
                      areItemsTheSame: (a, b) => a.message == b.message,
                      itemBuilder: (context, animation, item, index) {
                        return SizeFadeTransition(
                          animation: animation,

                          child: TextFormField(
                            readOnly: true,
                            initialValue: item.message,
                            decoration: InputDecorations.outlineBorder(
                              context: context,
                              prefixIcon: const Icon(Symbols.alarm),
                              borderRadius: 16,
                              suffixIcon: IconButton(
                                icon: Icon(Symbols.close),
                                onPressed: () {
                                  setState(() {
                                    userReminders.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    userReminders.length < 3
                        ? DropdownButtonFormField(
                          value: null,
                          items:
                              reminders
                                  .map(
                                    (option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option.message),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (userReminders.contains(value)) {
                              Future.microtask(
                                () => dropdownKey.currentState?.reset(),
                              );
                              return;
                            }
                            setState(() {
                              userReminders.add(value!);
                            });

                            Future.microtask(
                              () => dropdownKey.currentState?.reset(),
                            );
                          },
                          decoration: InputDecorations.outlineBorder(
                            context: context,
                            prefixIcon: const Icon(Symbols.alarm),
                            borderRadius: 16,
                            hintText: "Add a reminders...",
                          ),
                          key: dropdownKey,
                        )
                        : const SizedBox.shrink(),
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

class Reminder {
  Reminder({required this.message, required this.duration});

  Duration duration;
  String message;
}
