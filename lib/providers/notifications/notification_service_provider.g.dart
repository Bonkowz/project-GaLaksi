// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'f7d0094ce5d0cdc93985cba2c7f2fc831ea44a04';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider =
    AutoDisposeProvider<NotificationService>.internal(
      notificationService,
      name: r'notificationServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationServiceRef = AutoDisposeProviderRef<NotificationService>;
String _$notificationSyncServiceHash() =>
    r'eabc6b06603ac23cb1d1979584a7495c981e52db';

/// See also [notificationSyncService].
@ProviderFor(notificationSyncService)
final notificationSyncServiceProvider =
    AutoDisposeProvider<NotificationSyncService>.internal(
      notificationSyncService,
      name: r'notificationSyncServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationSyncServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationSyncServiceRef =
    AutoDisposeProviderRef<NotificationSyncService>;
String _$userNotificationsStreamHash() =>
    r'f0428e0061f5963dae9082c75d131e8658d6a644';

/// See also [userNotificationsStream].
@ProviderFor(userNotificationsStream)
final userNotificationsStreamProvider =
    AutoDisposeStreamProvider<List<UserNotification>>.internal(
      userNotificationsStream,
      name: r'userNotificationsStreamProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userNotificationsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserNotificationsStreamRef =
    AutoDisposeStreamProviderRef<List<UserNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
