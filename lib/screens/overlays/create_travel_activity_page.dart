import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/widgets/place_autocomplete.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateTravelActivityPage extends ConsumerStatefulWidget {
  const CreateTravelActivityPage({super.key});

  @override
  ConsumerState<CreateTravelActivityPage> createState() =>
      _CreateTravelActivityPageState();
}

class _CreateTravelActivityPageState
    extends ConsumerState<CreateTravelActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final activityDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  bool _isLoading = false;

  Future<void> submit() async {}

  @override
  void dispose() {
    titleTextController.dispose();
    activityDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  DateTime? activityDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  /// Utility function for FormField
  String dateToString(DateTime date) {
    return "${DateFormat('MMMM').format(DateTime(0, date.month))} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  /// Utility function for FormField
  String timeToString(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }

  final reminders = ["5 minutes before", "10 minutes before", "1 hour before"];

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
                      ).copyWith(
                        counterText: "${titleTextController.text.length}",
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
                              if (startTime == null || endTime == null) {
                                return null; // can't validate yet
                              }

                              if (startTime!.compareTo(endTime!) >= 0) {
                                return "Invalid time!";
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
                              if (startTime == null || endTime == null) {
                                return null; // can't validate yet
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
                    PlaceAutocomplete(),
                    DropdownButtonFormField(
                      items:
                          ['1 hour before', '6 hours before', '1 day before']
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {},
                      decoration: InputDecorations.outlineBorder(
                        context: context,
                        prefixIcon: Icon(Symbols.alarm),
                        borderRadius: 16,
                        hintText: "Remind me...",
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
