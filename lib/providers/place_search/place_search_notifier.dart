import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/http_client/http_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_notifier.g.dart';

@riverpod
class PlaceSearch extends _$PlaceSearch {
  @override
  FutureOr<List<String>> build() {
    return [];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    final client = ref.read(httpClientProvider);
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '10',
    });

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final response = await client.get(
        uri,
        headers: {'User-Agent': 'galaksi (jcmagpantay@up.edu.ph)'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch places from Nominatim: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body) as List;

      final places =
          data.map((place) => place['display_name'] as String).toList();

      return places;
    });
  }
}
