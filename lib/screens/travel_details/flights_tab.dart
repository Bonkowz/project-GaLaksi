import 'package:flutter/material.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/models/travel_plan/flight_detail_model.dart';
import 'package:galaksi/screens/overlays/add_flight_page.dart'; // Corrected line

class FlightsTab extends StatelessWidget {
  FlightsTab({required this.travelPlanId, required this.flights, super.key});

  final String travelPlanId;
  final List<FlightDetail> flights;

  // final List<FlightDetail> dummyFlights = [
  //   FlightDetail(
  //     flightNumber: "UA123",
  //     airline: "United Airlines",
  //     location: "Denver (DEN)",
  //     destination: "Kathmandu (KTM)",
  //     departureAt: DateTime(2025, 5, 1, 10, 0), // May 1, 2025, 3:00 PM
  //   ),
  //   FlightDetail(
  //     flightNumber: "QR456",
  //     airline: "Qatar Airways",
  //     location: "Kathmandu (KTM)",
  //     destination: "Lukla (LUA)",
  //     departureAt: DateTime(2025, 5, 3, 7, 30), // May 3, 2025, 7:30 AM
  //   ),
  //   FlightDetail(
  //     flightNumber: "RA789",
  //     airline: "Nepal Airlines",
  //     location: "Lukla (LUA)",
  //     destination: "Kathmandu (KTM)",
  //     departureAt: DateTime(2025, 6, 8, 14, 0), // June 8, 2025, 2:00 PM
  //   ),
  //   FlightDetail(
  //     flightNumber: "UA987",
  //     airline: "United Airlines",
  //     location: "Kathmandu (KTM)",
  //     destination: "Denver (DEN)",
  //     departureAt: DateTime(2025, 6, 10, 18, 0), // June 10, 2025, 6:00 PM
  //   ),
  //   FlightDetail(
  //     flightNumber: "BA321",
  //     airline: "British Airways",
  //     location: "London (LHR)",
  //     destination: "Kathmandu (KTM)",
  //     departureAt: DateTime(2025, 4, 29, 20, 0), // April 29, 2025, 8:00 PM
  //   ),
  //   FlightDetail(
  //     flightNumber: "Flight 101",
  //     airline: "Cebu Pacific",
  //     location: "Manila (MNL)",
  //     destination: "Nagoya (NPL)",
  //     departureAt: DateTime(2025, 5, 1, 10, 0),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreateDetailsButton(
            text: "Add a flight...",
            leadingIcon: const Icon(Symbols.add),
            trailingIcon: const Icon(Symbols.flight),
            navigateTo: AddFlightPage(travelPlanId: travelPlanId),
          ),
        ),
        SliverList.builder(
          itemCount: flights.length,
          itemBuilder: (context, index) {
            final flight = flights[index];
            final originCode = flight.location;
            final destinationCode = flight.destination;

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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$originCode to $destinationCode",
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
                                  flight.airline,
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
                                Symbols.description,
                                size: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  flight.flightNumber,
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
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   icon: const Icon(Symbols.edit, size: 20),
                        //   onPressed: () {
                        //     // TODO: Implement edit functionality for flight
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(Symbols.delete, size: 20),
                          onPressed: () {
                            // TODO: Implement delete functionality for flight
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
