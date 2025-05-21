import 'package:flutter/material.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/models/travel_plan/accommodation_model.dart';

class AccommodationsTab extends StatelessWidget {
  AccommodationsTab({required this.accommodations, super.key});
  final List<Accommodation> accommodations;

  final List<Accommodation> dummyAccommodations = [
    Accommodation(
      name: "Kathmandu Guest House",
      checkIn: DateTime(2025, 5, 1, 15, 0), // May 1, 2025, 3:00 PM
      checkOut: DateTime(2025, 5, 3, 11, 0), // May 3, 2025, 11:00 AM
      location: "Thamel, Kathmandu",
    ),
    Accommodation(
      name: "Everest Base Camp Lodge",
      checkIn: DateTime(2025, 5, 5, 12, 0), // May 5, 2025, 12:00 PM
      checkOut: DateTime(2025, 5, 6, 10, 0), // May 6, 2025, 10:00 AM
      location: "Everest Base Camp",
    ),
    Accommodation(
      name: "Trekker's Inn Namche Bazaar",
      checkIn: DateTime(2025, 5, 3, 14, 0), // May 3, 2025, 2:00 PM
      checkOut: DateTime(2025, 5, 5, 10, 0), // May 5, 2025, 10:00 AM
      location: "Namche Bazaar",
    ),
    Accommodation(
      name: "Hotel Yak & Yeti",
      checkIn: DateTime(2025, 6, 8, 15, 0), // June 8, 2025, 3:00 PM
      checkOut: DateTime(2025, 6, 10, 11, 0), // June 10, 2025, 11:00 AM
      location: "Kathmandu",
    ),
    Accommodation(
      name: "Summit View Teahouse",
      checkIn: DateTime(2025, 5, 25, 16, 0), // May 25, 2025, 4:00 PM
      checkOut: DateTime(2025, 5, 27, 9, 0), // May 27, 2025, 9:00 AM
      location: "Gorak Shep",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateDetailsButton(
          text: "Add an accommodation...",
          leadingIcon: const Icon(
            Symbols.add,
          ),
          trailingIcon: const Icon(Symbols.hotel),
          navigateTo: CreateTravelActivityPage(),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyAccommodations.length,
            itemBuilder: (context, index) {
              final accommodation = dummyAccommodations[index];
              final formattedCheckInDate =
                  "${accommodation.checkIn.toLocal().month}/${accommodation.checkIn.toLocal().day}/${accommodation.checkIn.toLocal().year}";
              final formattedCheckInTime =
                  "${accommodation.checkIn.toLocal().hour}:${accommodation.checkIn.toLocal().minute.toString().padLeft(2, '0')}";
              final formattedCheckOutDate =
                  "${accommodation.checkOut.toLocal().month}/${accommodation.checkOut.toLocal().day}/${accommodation.checkOut.toLocal().year}";
              final formattedCheckOutTime =
                  "${accommodation.checkOut.toLocal().hour}:${accommodation.checkOut.toLocal().minute.toString().padLeft(2, '0')}";

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Card.outlined(
                  color: Theme.of(context).colorScheme.onPrimary,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge 
                                    ?.copyWith(
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
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      accommodation.location,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface,
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
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    "$formattedCheckInDate at $formattedCheckInTime",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    "$formattedCheckOutDate at $formattedCheckOutTime",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                print('Edit accommodation: ${accommodation.name}');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Symbols.delete, size: 20),
                              onPressed: () {
                                // TODO: Implement delete functionality
                                print('Delete accommodation: ${accommodation.name}');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}