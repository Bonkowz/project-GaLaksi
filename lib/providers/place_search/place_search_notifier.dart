import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/http_client/http_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_notifier.g.dart';

@riverpod
class PlaceSearch extends _$PlaceSearch {
  @override
  PlaceSearchState build() {
    state = const PlaceSearchState();

    return state;
  }

  FutureOr<List<Place>> search(String query) async {
    debugPrint("Hello");
    if (query.trim().isEmpty) return List<Place>.empty();

    /// Gets the client and fetches from Nominatim
    final client = ref.read(httpClientProvider);
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '5',
    });

    final response = await client.get(
      uri,

      // For security reasons, on Nominatim's side
      headers: {'User-Agent': 'galaksi (jcmagpantay@up.edu.ph)'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed: ${response.statusCode}');
    }

    // Parse String response into JSON
    final decoded = jsonDecode(response.body);

    // If not List, throw an error
    if (decoded is! List) {
      throw Exception('Expected a List, got: ${decoded.runtimeType}');
    }

    // Convert to Place
    final places =
        (decoded)
            .map((json) => Place.fromMap(json as Map<String, dynamic>))
            .toList();

    state = state.copyWith(lastPlaces: places);

    state = state.copyWith(places: places);
    debugPrint("Helly: ${places.toString()}");

    return state.places;
  }

  void clear() {
    state = const PlaceSearchState();
  }
}

class PlaceSearchState {
  const PlaceSearchState({this.lastPlaces, this.places = const []});

  final List<Place>? lastPlaces;
  final List<Place> places;

  PlaceSearchState copyWith({List<Place>? lastPlaces, List<Place>? places}) {
    return PlaceSearchState(
      lastPlaces: lastPlaces ?? this.lastPlaces,
      places: places ?? this.places,
    );
  }
}
