// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserProfileStreamHash() =>
    r'62d68e389534cfee13f2947b8348cb97293a9b70';

/// See also [currentUserProfileStream].
@ProviderFor(currentUserProfileStream)
final currentUserProfileStreamProvider =
    AutoDisposeStreamProvider<User?>.internal(
      currentUserProfileStream,
      name: r'currentUserProfileStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserProfileStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileStreamRef = AutoDisposeStreamProviderRef<User?>;
String _$userProfileStreamHash() => r'b8b44bcfe7ec493ecb4da72a567d8ede3f1e20b2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userProfileStream].
@ProviderFor(userProfileStream)
const userProfileStreamProvider = UserProfileStreamFamily();

/// See also [userProfileStream].
class UserProfileStreamFamily extends Family<AsyncValue<User>> {
  /// See also [userProfileStream].
  const UserProfileStreamFamily();

  /// See also [userProfileStream].
  UserProfileStreamProvider call(String userId) {
    return UserProfileStreamProvider(userId);
  }

  @override
  UserProfileStreamProvider getProviderOverride(
    covariant UserProfileStreamProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userProfileStreamProvider';
}

/// See also [userProfileStream].
class UserProfileStreamProvider extends AutoDisposeStreamProvider<User> {
  /// See also [userProfileStream].
  UserProfileStreamProvider(String userId)
    : this._internal(
        (ref) => userProfileStream(ref as UserProfileStreamRef, userId),
        from: userProfileStreamProvider,
        name: r'userProfileStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userProfileStreamHash,
        dependencies: UserProfileStreamFamily._dependencies,
        allTransitiveDependencies:
            UserProfileStreamFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserProfileStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<User> Function(UserProfileStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfileStreamProvider._internal(
        (ref) => create(ref as UserProfileStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<User> createElement() {
    return _UserProfileStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserProfileStreamRef on AutoDisposeStreamProviderRef<User> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProfileStreamProviderElement
    extends AutoDisposeStreamProviderElement<User>
    with UserProfileStreamRef {
  _UserProfileStreamProviderElement(super.provider);

  @override
  String get userId => (origin as UserProfileStreamProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
