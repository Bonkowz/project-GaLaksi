// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_plan_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$travelPlanUsersHash() => r'55373bedd1720e1c237d8e701627098e516ec1bc';

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

/// See also [travelPlanUsers].
@ProviderFor(travelPlanUsers)
const travelPlanUsersProvider = TravelPlanUsersFamily();

/// See also [travelPlanUsers].
class TravelPlanUsersFamily
    extends Family<AsyncValue<Map<String, List<User>>?>> {
  /// See also [travelPlanUsers].
  const TravelPlanUsersFamily();

  /// See also [travelPlanUsers].
  TravelPlanUsersProvider call(TravelPlan travelPlan) {
    return TravelPlanUsersProvider(travelPlan);
  }

  @override
  TravelPlanUsersProvider getProviderOverride(
    covariant TravelPlanUsersProvider provider,
  ) {
    return call(provider.travelPlan);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'travelPlanUsersProvider';
}

/// See also [travelPlanUsers].
class TravelPlanUsersProvider
    extends AutoDisposeFutureProvider<Map<String, List<User>>?> {
  /// See also [travelPlanUsers].
  TravelPlanUsersProvider(TravelPlan travelPlan)
    : this._internal(
        (ref) => travelPlanUsers(ref as TravelPlanUsersRef, travelPlan),
        from: travelPlanUsersProvider,
        name: r'travelPlanUsersProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$travelPlanUsersHash,
        dependencies: TravelPlanUsersFamily._dependencies,
        allTransitiveDependencies:
            TravelPlanUsersFamily._allTransitiveDependencies,
        travelPlan: travelPlan,
      );

  TravelPlanUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.travelPlan,
  }) : super.internal();

  final TravelPlan travelPlan;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<User>>?> Function(TravelPlanUsersRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TravelPlanUsersProvider._internal(
        (ref) => create(ref as TravelPlanUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        travelPlan: travelPlan,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<User>>?> createElement() {
    return _TravelPlanUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TravelPlanUsersProvider && other.travelPlan == travelPlan;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, travelPlan.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TravelPlanUsersRef
    on AutoDisposeFutureProviderRef<Map<String, List<User>>?> {
  /// The parameter `travelPlan` of this provider.
  TravelPlan get travelPlan;
}

class _TravelPlanUsersProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, List<User>>?>
    with TravelPlanUsersRef {
  _TravelPlanUsersProviderElement(super.provider);

  @override
  TravelPlan get travelPlan => (origin as TravelPlanUsersProvider).travelPlan;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
