// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserStreamHash() => r'1db7473a73ec080823d9b1b9bf847d48c9f3b755';

/// Provides the current user depending on the authentication state
///
/// If signed-in, the [Stream] returns the [User], otherwise it returns null.
///
/// Copied from [currentUserStream].
@ProviderFor(currentUserStream)
final currentUserStreamProvider = AutoDisposeStreamProvider<User?>.internal(
  currentUserStream,
  name: r'currentUserStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserStreamRef = AutoDisposeStreamProviderRef<User?>;
String _$authNotifierHash() => r'23b21b201cdd7888f2796a0082064aa4b79d23a3';

/// A [Notifier] that manages the state of the [AuthScreen]
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
