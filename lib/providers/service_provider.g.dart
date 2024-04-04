// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allServiceHash() => r'fa7148db398da8c857f9d4f999f0571e759f6ccc';

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

typedef AllServiceRef = AutoDisposeFutureProviderRef<List<ServiceModel>>;

/// See also [allService].
@ProviderFor(allService)
const allServiceProvider = AllServiceFamily();

/// See also [allService].
class AllServiceFamily extends Family<AsyncValue<List<ServiceModel>>> {
  /// See also [allService].
  const AllServiceFamily();

  /// See also [allService].
  AllServiceProvider call(
    String reservationId,
  ) {
    return AllServiceProvider(
      reservationId,
    );
  }

  @override
  AllServiceProvider getProviderOverride(
    covariant AllServiceProvider provider,
  ) {
    return call(
      provider.reservationId,
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
  String? get name => r'allServiceProvider';
}

/// See also [allService].
class AllServiceProvider extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// See also [allService].
  AllServiceProvider(
    this.reservationId,
  ) : super.internal(
          (ref) => allService(
            ref,
            reservationId,
          ),
          from: allServiceProvider,
          name: r'allServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allServiceHash,
          dependencies: AllServiceFamily._dependencies,
          allTransitiveDependencies:
              AllServiceFamily._allTransitiveDependencies,
        );

  final String reservationId;

  @override
  bool operator ==(Object other) {
    return other is AllServiceProvider && other.reservationId == reservationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reservationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$admminAllServiceHash() => r'f757654bd868f859354f78bd6be02c8f2951702a';
typedef AdmminAllServiceRef = AutoDisposeFutureProviderRef<List<ServiceModel>>;

/// See also [admminAllService].
@ProviderFor(admminAllService)
const admminAllServiceProvider = AdmminAllServiceFamily();

/// See also [admminAllService].
class AdmminAllServiceFamily extends Family<AsyncValue<List<ServiceModel>>> {
  /// See also [admminAllService].
  const AdmminAllServiceFamily();

  /// See also [admminAllService].
  AdmminAllServiceProvider call(
    String serviceStatus,
  ) {
    return AdmminAllServiceProvider(
      serviceStatus,
    );
  }

  @override
  AdmminAllServiceProvider getProviderOverride(
    covariant AdmminAllServiceProvider provider,
  ) {
    return call(
      provider.serviceStatus,
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
  String? get name => r'admminAllServiceProvider';
}

/// See also [admminAllService].
class AdmminAllServiceProvider
    extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// See also [admminAllService].
  AdmminAllServiceProvider(
    this.serviceStatus,
  ) : super.internal(
          (ref) => admminAllService(
            ref,
            serviceStatus,
          ),
          from: admminAllServiceProvider,
          name: r'admminAllServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$admminAllServiceHash,
          dependencies: AdmminAllServiceFamily._dependencies,
          allTransitiveDependencies:
              AdmminAllServiceFamily._allTransitiveDependencies,
        );

  final String serviceStatus;

  @override
  bool operator ==(Object other) {
    return other is AdmminAllServiceProvider &&
        other.serviceStatus == serviceStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
