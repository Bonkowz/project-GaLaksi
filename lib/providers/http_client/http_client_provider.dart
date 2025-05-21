import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart'; // required for code generation

@riverpod
http.Client httpClient(Ref ref) {
  final client = http.Client();
  return client;
}
