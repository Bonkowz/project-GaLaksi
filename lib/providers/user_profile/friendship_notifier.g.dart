// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendshipStreamHash() => r'9220e0331487d28fcb70d92fde8eb15688ef5dcb';

/// See also [friendshipStream].
@ProviderFor(friendshipStream)
final friendshipStreamProvider =
    AutoDisposeStreamProvider<List<Friendship>>.internal(
      friendshipStream,
      name: r'friendshipStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$friendshipStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendshipStreamRef = AutoDisposeStreamProviderRef<List<Friendship>>;
String _$friendshipNotifierHash() =>
    r'23dd5c6745f681cefa8fc0255d35d2dfc009c621';

/// See also [FriendshipNotifier].
@ProviderFor(FriendshipNotifier)
final friendshipNotifierProvider =
    NotifierProvider<FriendshipNotifier, List<Friendship>>.internal(
      FriendshipNotifier.new,
      name: r'friendshipNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$friendshipNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FriendshipNotifier = Notifier<List<Friendship>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
