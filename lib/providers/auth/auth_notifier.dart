import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_auth_api.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:galaksi/screens/auth/auth_screen.dart';
import 'package:galaksi/screens/auth/sign_in_page.dart';
import 'package:galaksi/screens/auth/sign_up_page.dart';

part 'auth_notifier.g.dart';

/// A [Notifier] that manages the state of the [AuthScreen]
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Initial state
    state = AuthState(isLoading: true);

    // Automatically fetch the user profile from the database
    // if the user is signed in
    ref.listen(currentUserStreamProvider, (previous, next) async {
      final firebaseUser = next.valueOrNull;
      if (firebaseUser != null) {
        await _fetchUserProfile(firebaseUser.uid);
      } else {
        state = AuthState();
      }
    }, fireImmediately: true);

    return state;
  }

  /// Fetches the user profile
  Future<void> _fetchUserProfile(String uid) async {
    state = state.copyWith(isLoading: true);
    final result = await FirebaseFirestoreApi().getUserDocumentByUid(uid);

    result.when(
      onSuccess: (success) {
        final userProfile = User.fromDocument(success.data);
        state = state.copyWith(user: userProfile, isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(user: null, isLoading: false);
      },
    );
  }

  /// Toggles between [SignInPage] and [SignUpPage] in the [AuthScreen]
  void switchPages() {
    state = state.copyWith(isSignIn: !state.isSignIn);
  }

  /// Attempts to sign in with the given email and password
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await FirebaseAuthApi().signIn(email, password);
    state = state.copyWith(isLoading: false);
    return result;
  }

  /// Attempts to sign in with the given username and password
  Future<AuthResult> signInWithUsername({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    // Fetch the user from the database
    final result = await FirebaseFirestoreApi().getUserDocumentByUsername(
      username,
    );

    return result.when(
      onSuccess: (success) async {
        // Attempt to sign in using the user's email
        final user = User.fromDocument(success.data);
        final result = await FirebaseAuthApi().signIn(user.email, password);
        state = state.copyWith(user: user);
        state = state.copyWith(isLoading: false);
        return result;
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false);

        return switch (failure.error) {
          FirestoreFailureError.networkError => const AuthResult(
            success: false,
            message: "You are offline. Please try again later.",
          ),
          FirestoreFailureError.notFound => const AuthResult(
            success: false,
            message: "Incorrect username or password.",
          ),
          _ => const AuthResult(
            success: false,
            message: "An unknown error occurred",
          ),
        };
      },
    );
  }

  /// Attempts to sign up with the given email and password
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await FirebaseAuthApi().signUp(email, password);
    state = state.copyWith(isLoading: false);
    return result;
  }

  /// Signs out of the application
  void signOut() {
    FirebaseAuthApi().signOut();
  }

  /// Deletes the user and signs them out of the application
  Future<void> signOutAndDelete() async {
    final currentUser = ref.watch(currentUserStreamProvider);
    currentUser.whenData((user) async {
      if (user == null) {
        return;
      }
      final result = await FirebaseFirestoreApi().getUserDocumentByUid(
        user.uid,
      );
      result.when(
        onSuccess: (success) async {
          await FirebaseFirestoreApi().deleteUser(success.data.id);
          FirebaseAuthApi().delete();
        },
        onFailure: (failure) {
          debugPrint(failure.message);
        },
      );
    });
  }
}

/// Represents the state of the [AuthScreen]
class AuthState {
  AuthState({this.isSignIn = true, this.isLoading = false, this.user});

  /// Whether the current page is the [SignInPage]
  final bool isSignIn;

  /// Whether the app is waiting for a sign in or sign up result to finish
  final bool isLoading;

  /// The current user's profile
  final User? user;

  /// Returns a copy of this [AuthState] but with the given fields replaced
  AuthState copyWith({bool? isSignIn, bool? isLoading, User? user}) {
    return AuthState(
      isSignIn: isSignIn ?? this.isSignIn,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

/// Provides the current user depending on the authentication state
///
/// If signed-in, the [Stream] returns the [User], otherwise it returns null.
@riverpod
Stream<auth.User?> currentUserStream(Ref ref) {
  return FirebaseAuthApi().getUser();
}
