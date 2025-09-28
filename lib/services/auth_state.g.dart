// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentAuthStateHash() => r'1a33388c44634dffe79ad4229ad51eb6c9c8b4f9';

/// The current authentication state of the app.
///
/// This notifier is responsible for saving/removing the token and profile info
/// to the storage through the [login] and [logout] methods.
///
/// Copied from [CurrentAuthState].
@ProviderFor(CurrentAuthState)
final currentAuthStateProvider =
    AutoDisposeNotifierProvider<CurrentAuthState, AuthState>.internal(
  CurrentAuthState.new,
  name: r'currentAuthStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAuthStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentAuthState = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
