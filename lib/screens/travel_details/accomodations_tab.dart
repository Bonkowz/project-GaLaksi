import 'package:flutter/material.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/models/travel_plan/accommodation_model.dart';
import 'package:galaksi/screens/overlays/add_accomodation_page.dart';

class AccommodationsTab extends StatelessWidget {
  AccommodationsTab({
    required this.travelPlanId,
    required this.accommodations,
    super.key,
  });
  final String travelPlanId;
  final List<Accommodation> accommodations;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreateDetailsButton(
            text: "Add an accommodation...",
            leadingIcon: const Icon(Symbols.add),
            trailingIcon: const Icon(Symbols.hotel),
            navigateTo: AddAccommodationPage(travelPlanId: travelPlanId),
          ),
        ),
        SliverList.builder(
          itemCount: accommodations.length,
          itemBuilder: (context, index) {
            final accommodation = accommodations[index];
            final formattedCheckInDate =
                "${accommodation.checkIn.toLocal().month}/${accommodation.checkIn.toLocal().day}/${accommodation.checkIn.toLocal().year}";
            final formattedCheckInTime =
                "${accommodation.checkIn.toLocal().hour}:${accommodation.checkIn.toLocal().minute.toString().padLeft(2, '0')}";
            final formattedCheckOutDate =
                "${accommodation.checkOut.toLocal().month}/${accommodation.checkOut.toLocal().day}/${accommodation.checkOut.toLocal().year}";
            final formattedCheckOutTime =
                "${accommodation.checkOut.toLocal().hour}:${accommodation.checkOut.toLocal().minute.toString().padLeft(2, '0')}";

            return Card.outlined(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accommodation.name,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Icon(
                                Symbols.location_on,
                                size: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  accommodation.location,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                Symbols.calendar_month,
                                size: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "$formattedCheckInDate at $formattedCheckInTime",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Icon(
                                Symbols.calendar_month,
                                size: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "$formattedCheckOutDate at $formattedCheckOutTime",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Symbols.edit, size: 20),
                          onPressed: () {
                            // TODO: Implement edit functionality
                            debugPrint(
                              'Edit accommodation: ${accommodation.name}',
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Symbols.delete, size: 20),
                          onPressed: () {
                            // TODO: Implement delete functionality
                            debugPrint(
                              'Delete accommodation: ${accommodation.name}',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
