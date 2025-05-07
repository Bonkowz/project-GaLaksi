import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/screens/onboarding/onboarding_1_identity.dart';
import 'package:galaksi/screens/onboarding/onboarding_2_security.dart';
import 'package:galaksi/screens/onboarding/onboarding_3_name.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    }
  }

  void nextPage() {
    if (state.currentIndex < state.pages.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void updateEmail(String email) {
    // TODO: Check if unique
    state = state.copyWith(email: email);
  }

  void updateUsername(String username) {
    // TODO: Check if unique
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

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  Future<AuthResult> createAccount() async {
    return await FirebaseAuthApi().signUp(state.email!, state.password!);
  }

  void toggleIsLoading() {
    state = state.copyWith(isLoading: !state.isLoading);
  }
}

class OnboardingState {
  OnboardingState({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.interests,
    this.travelStyles,
    this.currentIndex = 0,
    this.isLoading = false,
  });

  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;
  List<String>? interests;
  List<String>? travelStyles;
  int currentIndex;
  bool isLoading;

  final List<Widget> pages = [
    const Onboarding1Identity(),
    const Onboarding2Security(),
    const Onboarding3Name(),
  ];

  OnboardingState copyWith({
    firstName,
    lastName,
    email,
    username,
    password,
    confirmPassword,
    interests,
    travelStyles,
    currentIndex,
    isLoading,
  }) {
    return OnboardingState(
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
