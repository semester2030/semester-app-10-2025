// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_drivers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allDriversHash() => r'a21f68b956491111c7eb9115202890820f0c54c6';

/// Provider to fetch all available drivers
/// Returns a list of UserSignupModel where isDriver is true
///
/// Copied from [allDrivers].
@ProviderFor(allDrivers)
final allDriversProvider =
    AutoDisposeFutureProvider<List<UserSignupModel>>.internal(
  allDrivers,
  name: r'allDriversProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allDriversHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllDriversRef = AutoDisposeFutureProviderRef<List<UserSignupModel>>;
String _$allDriversStreamHash() => r'a551cf086822cef231588773df7ccc7b37d6afa9';

/// Provider to fetch all available drivers with real-time updates
/// This provider automatically refreshes when driver data changes
///
/// Copied from [allDriversStream].
@ProviderFor(allDriversStream)
final allDriversStreamProvider =
    AutoDisposeStreamProvider<List<UserSignupModel>>.internal(
  allDriversStream,
  name: r'allDriversStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allDriversStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllDriversStreamRef
    = AutoDisposeStreamProviderRef<List<UserSignupModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
