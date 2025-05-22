import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/user/user_model.dart';

part 'user_profile_notifier.g.dart';

@riverpod
Stream<User?> currentUserProfileStream(Ref ref) {
  final currentAuthUser = ref.watch(currentUserStreamProvider).valueOrNull;

  if (currentAuthUser == null) return Stream.value(null);

  final docStream =
      FirebaseFirestoreApi()
          .getUserDocumentStream(currentAuthUser.uid)
          .valueOrNull;

  if (docStream == null) {
    throw Exception('User document stream not found for current user');
  }

  return docStream.map((snapshot) => User.fromDocument(snapshot));
}

@riverpod
Stream<User> userProfileStream(Ref ref, String userId) {
  final docStream =
      FirebaseFirestoreApi().getUserDocumentStream(userId).valueOrNull;

  if (docStream == null) {
    throw Exception('User document stream not found for userId: $userId');
  }

  return docStream.map((snapshot) => User.fromDocument(snapshot));
}
