// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driverDetailsHash() => r'fc921e9e28a802e1b70f116a52fcd9fb6471c9b8';

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

/// Provider that fetches driver details by email
///
/// Copied from [driverDetails].
@ProviderFor(driverDetails)
const driverDetailsProvider = DriverDetailsFamily();

/// Provider that fetches driver details by email
///
/// Copied from [driverDetails].
class DriverDetailsFamily extends Family<AsyncValue<UserSignupModel?>> {
  /// Provider that fetches driver details by email
  ///
  /// Copied from [driverDetails].
  const DriverDetailsFamily();

  /// Provider that fetches driver details by email
  ///
  /// Copied from [driverDetails].
  DriverDetailsProvider call(
    String id,
  ) {
    return DriverDetailsProvider(
      id,
    );
  }

  @override
  DriverDetailsProvider getProviderOverride(
    covariant DriverDetailsProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'driverDetailsProvider';
}

/// Provider that fetches driver details by email
///
/// Copied from [driverDetails].
class DriverDetailsProvider
    extends AutoDisposeFutureProvider<UserSignupModel?> {
  /// Provider that fetches driver details by email
  ///
  /// Copied from [driverDetails].
  DriverDetailsProvider(
    String id,
  ) : this._internal(
          (ref) => driverDetails(
            ref as DriverDetailsRef,
            id,
          ),
          from: driverDetailsProvider,
          name: r'driverDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$driverDetailsHash,
          dependencies: DriverDetailsFamily._dependencies,
          allTransitiveDependencies:
              DriverDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  DriverDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<UserSignupModel?> Function(DriverDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DriverDetailsProvider._internal(
        (ref) => create(ref as DriverDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserSignupModel?> createElement() {
    return _DriverDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DriverDetailsRef on AutoDisposeFutureProviderRef<UserSignupModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DriverDetailsProviderElement
    extends AutoDisposeFutureProviderElement<UserSignupModel?>
    with DriverDetailsRef {
  _DriverDetailsProviderElement(super.provider);

  @override
  String get id => (origin as DriverDetailsProvider).id;
}

String _$driverStatsHash() => r'efbeef9b5c1500de8bf014c056f709ac71241550';

/// Provider for driver statistics
///
/// Copied from [driverStats].
@ProviderFor(driverStats)
const driverStatsProvider = DriverStatsFamily();

/// Provider for driver statistics
///
/// Copied from [driverStats].
class DriverStatsFamily extends Family<Map<String, dynamic>> {
  /// Provider for driver statistics
  ///
  /// Copied from [driverStats].
  const DriverStatsFamily();

  /// Provider for driver statistics
  ///
  /// Copied from [driverStats].
  DriverStatsProvider call(
    UserSignupModel? driver,
  ) {
    return DriverStatsProvider(
      driver,
    );
  }

  @override
  DriverStatsProvider getProviderOverride(
    covariant DriverStatsProvider provider,
  ) {
    return call(
      provider.driver,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'driverStatsProvider';
}

/// Provider for driver statistics
///
/// Copied from [driverStats].
class DriverStatsProvider extends AutoDisposeProvider<Map<String, dynamic>> {
  /// Provider for driver statistics
  ///
  /// Copied from [driverStats].
  DriverStatsProvider(
    UserSignupModel? driver,
  ) : this._internal(
          (ref) => driverStats(
            ref as DriverStatsRef,
            driver,
          ),
          from: driverStatsProvider,
          name: r'driverStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$driverStatsHash,
          dependencies: DriverStatsFamily._dependencies,
          allTransitiveDependencies:
              DriverStatsFamily._allTransitiveDependencies,
          driver: driver,
        );

  DriverStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.driver,
  }) : super.internal();

  final UserSignupModel? driver;

  @override
  Override overrideWith(
    Map<String, dynamic> Function(DriverStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DriverStatsProvider._internal(
        (ref) => create(ref as DriverStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        driver: driver,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, dynamic>> createElement() {
    return _DriverStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverStatsProvider && other.driver == driver;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, driver.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DriverStatsRef on AutoDisposeProviderRef<Map<String, dynamic>> {
  /// The parameter `driver` of this provider.
  UserSignupModel? get driver;
}

class _DriverStatsProviderElement
    extends AutoDisposeProviderElement<Map<String, dynamic>>
    with DriverStatsRef {
  _DriverStatsProviderElement(super.provider);

  @override
  UserSignupModel? get driver => (origin as DriverStatsProvider).driver;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
