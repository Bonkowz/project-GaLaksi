import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/screens/onboarding/onboarding_4_account.dart';
import 'package:galaksi/screens/onboarding/onboarding_5_username.dart';
import 'package:galaksi/screens/onboarding/onboarding_1_name.dart';
import 'package:galaksi/screens/onboarding/onboarding_2_interests.dart';
import 'package:galaksi/screens/onboarding/onboarding_3_styles.dart';
import 'package:galaksi/screens/onboarding/onboarding_6_complete.dart';
import 'package:galaksi/utils/string_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'onboarding_notifier.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() {
    return OnboardingState();
  }

  void prevPage() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
      debugPrint("${state.currentIndex}");
    }
  }

  void nextPage() {
    if (state.currentIndex < OnboardingState.pages.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      debugPrint("${state.currentIndex}");
    }
  }

  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email.trim().toLowerCase());
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateInterests(Set<Interest> interests) {
    state = state.copyWith(interests: interests);
  }

  void updateTravelStyles(Set<TravelStyle> travelStyles) {
    state = state.copyWith(travelStyles: travelStyles);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
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

  Future<AuthResult> createAccount() async {
    return await FirebaseAuthApi().signUp(
      StringUtils.normalizeEmailKeepAlias(state.email!),
      state.password!,
    );
  }

  Future<bool> createProfile() async {
    // Get the UID of the currently signed in user
    final currentAuthUser = ref.watch(currentUserStreamProvider);
    final authUid = currentAuthUser.when(
      data: (user) => user?.uid,
      error: (error, stackTrace) {
        debugPrint("Error fetching current user: $stackTrace");
        return null;
      },
      loading: () {
        debugPrint("Auth data is loading.");
        return null;
      },
    );

    // If the UID is null, we cannot create a profile
    if (authUid == null) {
      debugPrint("Error creating profile: Did not obtain user UID");
      return false;
    }

    final user = User(
      uid: authUid,
      firstName: state.firstName!.trim(),
      lastName: state.lastName!.trim(),
      username: state.username!.trim(),
      email: StringUtils.normalizeEmailKeepAlias(state.email!),
      emailCanonical: StringUtils.normalizeEmail(state.email!),
      interests: state.interests,
      travelStyles: state.travelStyles,
      image: state.image ?? '',
    );
    final result = await FirebaseFirestoreApi().addUser(user);
    return result.when(
      onSuccess: (success) {
        state = state.copyWith(uid: user.uid);
        return success.data;
      },
      onFailure: (failure) {
        debugPrint("Error creating user: ${failure.message}");
        return false;
      },
    );
  }
}

class OnboardingState {
  OnboardingState({
    this.uid,
    this.image,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.interests = const {},
    this.travelStyles = const {},
    this.currentIndex = 0,
    this.isLoading = false,
  });

  static const List<Widget> pages = [
    Onboarding1Name(),
    Onboarding2Interests(),
    Onboarding3Styles(),
    Onboarding4Account(),
    Onboarding5Username(),
    Onboarding6Complete(),
  ];

  String? uid;
  String? image;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;
  Set<Interest> interests;
  Set<TravelStyle> travelStyles;
  int currentIndex;
  bool isLoading;

  OnboardingState copyWith({
    String? uid,
    String? image,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    Set<Interest>? interests,
    Set<TravelStyle>? travelStyles,
    int? currentIndex,
    bool? isLoading,
  }) {
    return OnboardingState(
      uid: uid ?? this.uid,
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      interests: interests ?? this.interests,
      travelStyles: travelStyles ?? this.travelStyles,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
