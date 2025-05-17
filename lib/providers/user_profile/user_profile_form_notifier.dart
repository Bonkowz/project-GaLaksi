import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_form_notifier.g.dart';

@riverpod
class UserProfileFormNotifier extends _$UserProfileFormNotifier {
  @override
  UserProfileFormState build() {
    return UserProfileFormState();
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updateInterests(Set<Interest> interests) {
    state = state.copyWith(interests: interests);
  }

  void updateTravelStyles(Set<TravelStyle> travelStyles) {
    state = state.copyWith(travelStyles: travelStyles);
  }

  void updateImage(XFile? imageFile) {
    if (imageFile == null) {
      state = state.copyWith(image: ''); // Explicitly remove image
    } else {
      final serializedImage = base64Encode(
        File(imageFile.path).readAsBytesSync(),
      );
      state = state.copyWith(image: serializedImage);
    }
  }

  Future<bool> updateProfile() async {
    final user = ref.watch(authNotifierProvider).user;

    if (user == null) {
      debugPrint("Cannot update profile. It is null.");
      return false;
    }

    final updatedUser = user.copyWith(
      image: state.image ?? user.image,
      firstName: state.firstName,
      lastName: state.lastName,
      interests: state.interests,
      travelStyles: state.travelStyles,
    );

    final result = await FirebaseFirestoreApi().updateUser(user, updatedUser);
    return result.when(
      onSuccess: (success) {
        return success.data;
      },
      onFailure: (failure) {
        debugPrint("Failed to update user profile: ${failure.message}");
        return false;
      },
    );
  }
}

class UserProfileFormState {
  UserProfileFormState({
    this.firstName,
    this.lastName,
    this.uid,
    this.interests = const {},
    this.travelStyles = const {},
    this.image, // nullable by default
  });

  final String? uid;
  final String? image;
  final String? firstName;
  final String? lastName;
  final Set<Interest> interests;
  final Set<TravelStyle> travelStyles;

  UserProfileFormState copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    Set<Interest>? interests,
    Set<TravelStyle>? travelStyles,
    String? image,
  }) {
    return UserProfileFormState(
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      uid: uid ?? this.uid,
      interests: interests ?? this.interests,
      travelStyles: travelStyles ?? this.travelStyles,
    );
  }
}
