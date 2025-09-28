// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserDetailsHash() =>
    r'32e58d464dc02a414d033c425482c458360b2dac';

/// Provider that returns the current user details from Firebase
/// Returns UserSignupModel if user is logged in, null otherwise
///
/// Copied from [currentUserDetails].
@ProviderFor(currentUserDetails)
final currentUserDetailsProvider =
    AutoDisposeFutureProvider<UserSignupModel?>.internal(
  currentUserDetails,
  name: r'currentUserDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserDetailsRef = AutoDisposeFutureProviderRef<UserSignupModel?>;
String _$currentUserDetailsStreamHash() =>
    r'dcb5553f0fe1fadd124765664b42f2a9a0de1bcf';

/// Stream provider that listens to real-time updates of current user details
///
/// Copied from [currentUserDetailsStream].
@ProviderFor(currentUserDetailsStream)
final currentUserDetailsStreamProvider =
    AutoDisposeStreamProvider<UserSignupModel?>.internal(
  currentUserDetailsStream,
  name: r'currentUserDetailsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserDetailsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserDetailsStreamRef
    = AutoDisposeStreamProviderRef<UserSignupModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
