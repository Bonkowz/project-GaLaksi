import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw Exception('Expected a List, got: ${decoded.runtimeType}');
      }

      final places =
          (decoded as List)
              .map((json) => Place.fromJson(json as Map<String, dynamic>))
              .toList();

      lastPlaces = places;

      state = AsyncValue.data(places);
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

class Place {
  Place({required this.name, required this.displayName});

  // Factory constructor to create Place from JSON map
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
    );
  }

  final String name;
  final String displayName;
}
