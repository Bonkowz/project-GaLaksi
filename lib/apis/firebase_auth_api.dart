import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  /// Returns a [Stream] that notifies about changes to the user's sign-in state.
  ///
  /// If signed out, the stream contains null, if signed-in, the stream returns the signed-in user.
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  /// Returns an [AuthResult] depending on the success of the sign in attempt
  Future<AuthResult> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return const AuthResult(
        success: true,
        message: "Successfully signed in!",
      );
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        "invalid-email" => const AuthResult(
          success: false,
          message: "Please enter a valid email address.",
        ),
        "user-disabled" => const AuthResult(
          success: false,
          message: "This user is disabled. Please try again later.",
        ),
        "too-many-requests" => const AuthResult(
          success: false,
          message: "Too many requests. Please try again later.",
        ),
        "user-token-expired" => const AuthResult(
          success: false,
          message: "Your session expired. Please try again.",
        ),
        "network-request-failed" => const AuthResult(
          success: false,
          message: "You are not offline. Please try again later.",
        ),
        "operation-not-allowed" => const AuthResult(
          success: false,
          message: "Operation not allowed. Please try again later.",
        ),
        "invalid-credential" => const AuthResult(
          success: false,
          message: "Incorrect email or password.",
        ),
        _ => const AuthResult(
          success: false,
          message: "An unknown error occured.",
        ),
      };
    } catch (e) {
      return const AuthResult(
        success: false,
        message: "An unknown error occured.",
      );
    }
  }

  /// Returns an [AuthResult] depending on the success of the sign up attempt
  Future<AuthResult> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const AuthResult(
        success: true,
        message: "Successfully created account!",
      );
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        "email-already-in-use" => const AuthResult(
          success: false,
          message: "Please enter a different email address.",
        ),
        "invalid-email" => const AuthResult(
          success: false,
          message: "Please enter a valid email address.",
        ),
        "weak-password" => const AuthResult(
          success: false,
          message: "Please enter a stronger password.",
        ),
        "too-many-requests" => const AuthResult(
          success: false,
          message: "Too many requests. Please try again later.",
        ),
        "user-token-expired" => const AuthResult(
          success: false,
          message: "Your session expired. Please try again.",
        ),
        "network-request-failed" => const AuthResult(
          success: false,
          message: "You are not offline. Please try again later.",
        ),
        "operation-not-allowed" => const AuthResult(
          success: false,
          message: "Operation not allowed. Please try again later.",
        ),
        _ => const AuthResult(
          success: false,
          message: "An unknown error occured.",
        ),
      };
    } catch (e) {
      return const AuthResult(
        success: false,
        message: "An unknown error occured.",
      );
    }
  }

  /// Signs out the currently logged in user
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Deletes the currently logged in user
  Future<void> delete() async {
    await auth.currentUser?.delete();
  }
}

/// Represents a result of an authentication attempt
class AuthResult {
  const AuthResult({required this.success, required this.message});

  /// Whether the authentication attempt was successful or not
  final bool success;

  /// A message that explains the result of the authentication attempt
  final String message;
}
