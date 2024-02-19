// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_hotels_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allHotelsHash() => r'ed62e5b34bb9a60c416f022839db2e6149d9a184';

/// See also [allHotels].
@ProviderFor(allHotels)
final allHotelsProvider = AutoDisposeFutureProvider<List<HotelModel>>.internal(
  allHotels,
  name: r'allHotelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allHotelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllHotelsRef = AutoDisposeFutureProviderRef<List<HotelModel>>;
String _$favHotelsHash() => r'7a4596740a0376bee00d08354fe0f356a3200bdf';

/// See also [favHotels].
@ProviderFor(favHotels)
final favHotelsProvider = AutoDisposeFutureProvider<List<HotelModel>>.internal(
  favHotels,
  name: r'favHotelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$favHotelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavHotelsRef = AutoDisposeFutureProviderRef<List<HotelModel>>;
String _$selectedHotelHash() => r'f72991b5690da8c9ff374425d9b4b9bdd5230dae';

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

typedef SelectedHotelRef = AutoDisposeFutureProviderRef<List<HotelModel>>;

/// See also [selectedHotel].
@ProviderFor(selectedHotel)
const selectedHotelProvider = SelectedHotelFamily();

/// See also [selectedHotel].
class SelectedHotelFamily extends Family<AsyncValue<List<HotelModel>>> {
  /// See also [selectedHotel].
  const SelectedHotelFamily();

  /// See also [selectedHotel].
  SelectedHotelProvider call(
    String houseId,
  ) {
    return SelectedHotelProvider(
      houseId,
    );
  }

  @override
  SelectedHotelProvider getProviderOverride(
    covariant SelectedHotelProvider provider,
  ) {
    return call(
      provider.houseId,
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
  String? get name => r'selectedHotelProvider';
}

/// See also [selectedHotel].
class SelectedHotelProvider
    extends AutoDisposeFutureProvider<List<HotelModel>> {
  /// See also [selectedHotel].
  SelectedHotelProvider(
    this.houseId,
  ) : super.internal(
          (ref) => selectedHotel(
            ref,
            houseId,
          ),
          from: selectedHotelProvider,
          name: r'selectedHotelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedHotelHash,
          dependencies: SelectedHotelFamily._dependencies,
          allTransitiveDependencies:
              SelectedHotelFamily._allTransitiveDependencies,
        );

  final String houseId;

  @override
  bool operator ==(Object other) {
    return other is SelectedHotelProvider && other.houseId == houseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, houseId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
