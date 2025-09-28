// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userBookingsHash() => r'0ac3278f03a24252b393a3be6bee8675967924f6';

/// Provider that streams user bookings from Firebase
///
/// Copied from [userBookings].
@ProviderFor(userBookings)
final userBookingsProvider =
    AutoDisposeStreamProvider<List<RequestBookingModel>>.internal(
  userBookings,
  name: r'userBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserBookingsRef
    = AutoDisposeStreamProviderRef<List<RequestBookingModel>>;
String _$pendingAndActiveBookingsHash() =>
    r'cdc1b7a02dd331a644665440303df383b88f4509';

/// Provider for pending and active bookings specifically
///
/// Copied from [pendingAndActiveBookings].
@ProviderFor(pendingAndActiveBookings)
final pendingAndActiveBookingsProvider =
    AutoDisposeStreamProvider<List<RequestBookingModel>>.internal(
  pendingAndActiveBookings,
  name: r'pendingAndActiveBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingAndActiveBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingAndActiveBookingsRef
    = AutoDisposeStreamProviderRef<List<RequestBookingModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
