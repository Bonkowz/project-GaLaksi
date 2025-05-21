import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/http_client/http_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_notifier.g.dart';

@riverpod
class PlaceSearch extends _$PlaceSearch {
  /// Stores the previous places
  List<Place>? lastPlaces;

  @override
  FutureOr<List<Place>> build() {
    state = const AsyncData([]);
    return [];
  }

  FutureOr<List<Place>> search(String query) async {
    debugPrint("Hello");
    if (query.trim().isEmpty) return List<Place>.empty();

    var returnPlaces = List<Place>.empty();

    /// Gets the client and fetches from Nominatim
    final client = ref.read(httpClientProvider);
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '5',
    });

    state = const AsyncValue.loading();

    try {
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

      lastPlaces = places;

      state = AsyncValue.data(places);
      debugPrint("Helly: ${places.toString()}");
      returnPlaces = places;
    } catch (e, st) {
      debugPrint('Caught error: $e\n$st');
      state = AsyncValue.error(e, st);
      return lastPlaces ?? [];
    }

    return returnPlaces;
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}
