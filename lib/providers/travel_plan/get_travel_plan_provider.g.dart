// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_travel_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myTravelPlansStreamHash() =>
    r'dec423b2255bea0e716dde12ecf748c2d2acb044';

/// See also [myTravelPlansStream].
@ProviderFor(myTravelPlansStream)
final myTravelPlansStreamProvider = StreamProvider<List<TravelPlan>>.internal(
  myTravelPlansStream,
  name: r'myTravelPlansStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myTravelPlansStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyTravelPlansStreamRef = StreamProviderRef<List<TravelPlan>>;
String _$sharedTravelPlansStreamHash() =>
    r'90ed5962b8f2630daeac0f5267eb5d4ab0b217ba';

/// See also [sharedTravelPlansStream].
@ProviderFor(sharedTravelPlansStream)
final sharedTravelPlansStreamProvider =
    StreamProvider<List<TravelPlan>>.internal(
      sharedTravelPlansStream,
      name: r'sharedTravelPlansStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sharedTravelPlansStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedTravelPlansStreamRef = StreamProviderRef<List<TravelPlan>>;
String _$travelPlanStreamHash() => r'76781cbf92b1e0ab117926188eb320b2343d4ee8';

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

/// See also [travelPlanStream].
@ProviderFor(travelPlanStream)
const travelPlanStreamProvider = TravelPlanStreamFamily();

/// See also [travelPlanStream].
class TravelPlanStreamFamily extends Family<AsyncValue<TravelPlan?>> {
  /// See also [travelPlanStream].
  const TravelPlanStreamFamily();

  /// See also [travelPlanStream].
  TravelPlanStreamProvider call(String travelPlanId) {
    return TravelPlanStreamProvider(travelPlanId);
  }

  @override
  TravelPlanStreamProvider getProviderOverride(
    covariant TravelPlanStreamProvider provider,
  ) {
    return call(provider.travelPlanId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'travelPlanStreamProvider';
}

/// See also [travelPlanStream].
class TravelPlanStreamProvider extends AutoDisposeStreamProvider<TravelPlan?> {
  /// See also [travelPlanStream].
  TravelPlanStreamProvider(String travelPlanId)
    : this._internal(
        (ref) => travelPlanStream(ref as TravelPlanStreamRef, travelPlanId),
        from: travelPlanStreamProvider,
        name: r'travelPlanStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$travelPlanStreamHash,
        dependencies: TravelPlanStreamFamily._dependencies,
        allTransitiveDependencies:
            TravelPlanStreamFamily._allTransitiveDependencies,
        travelPlanId: travelPlanId,
      );

  TravelPlanStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.travelPlanId,
  }) : super.internal();

  final String travelPlanId;

  @override
  Override overrideWith(
    Stream<TravelPlan?> Function(TravelPlanStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TravelPlanStreamProvider._internal(
        (ref) => create(ref as TravelPlanStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        travelPlanId: travelPlanId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TravelPlan?> createElement() {
    return _TravelPlanStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TravelPlanStreamProvider &&
        other.travelPlanId == travelPlanId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, travelPlanId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TravelPlanStreamRef on AutoDisposeStreamProviderRef<TravelPlan?> {
  /// The parameter `travelPlanId` of this provider.
  String get travelPlanId;
}

class _TravelPlanStreamProviderElement
    extends AutoDisposeStreamProviderElement<TravelPlan?>
    with TravelPlanStreamRef {
  _TravelPlanStreamProviderElement(super.provider);

  @override
  String get travelPlanId => (origin as TravelPlanStreamProvider).travelPlanId;
}

String _$myTravelPlansSnapshotHash() =>
    r'39c846bcab993185e6bef57dd03881746cb36279';

/// See also [myTravelPlansSnapshot].
@ProviderFor(myTravelPlansSnapshot)
final myTravelPlansSnapshotProvider =
    AutoDisposeFutureProvider<List<TravelPlan>>.internal(
      myTravelPlansSnapshot,
      name: r'myTravelPlansSnapshotProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$myTravelPlansSnapshotHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyTravelPlansSnapshotRef =
    AutoDisposeFutureProviderRef<List<TravelPlan>>;
String _$sharedTravelPlansSnapshotHash() =>
    r'ae8c77b88f2a69949a86fbdde625fadbea387c4a';

/// See also [sharedTravelPlansSnapshot].
@ProviderFor(sharedTravelPlansSnapshot)
final sharedTravelPlansSnapshotProvider =
    AutoDisposeFutureProvider<List<TravelPlan>>.internal(
      sharedTravelPlansSnapshot,
      name: r'sharedTravelPlansSnapshotProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sharedTravelPlansSnapshotHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedTravelPlansSnapshotRef =
    AutoDisposeFutureProviderRef<List<TravelPlan>>;
String _$allTravelPlansSnapshotHash() =>
    r'243d436b8edfcbddb6d15ca87fa405bf062ea27a';

/// See also [allTravelPlansSnapshot].
@ProviderFor(allTravelPlansSnapshot)
final allTravelPlansSnapshotProvider =
    AutoDisposeFutureProvider<List<TravelPlan>>.internal(
      allTravelPlansSnapshot,
      name: r'allTravelPlansSnapshotProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allTravelPlansSnapshotHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTravelPlansSnapshotRef =
    AutoDisposeFutureProviderRef<List<TravelPlan>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
