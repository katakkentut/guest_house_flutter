// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allBookingHash() => r'250b57b9aef085e9d8ab30da8f84eb89991fc114';

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

typedef AllBookingRef = AutoDisposeFutureProviderRef<List<BookingModel>>;

/// See also [allBooking].
@ProviderFor(allBooking)
const allBookingProvider = AllBookingFamily();

/// See also [allBooking].
class AllBookingFamily extends Family<AsyncValue<List<BookingModel>>> {
  /// See also [allBooking].
  const AllBookingFamily();

  /// See also [allBooking].
  AllBookingProvider call(
    String bookingType,
  ) {
    return AllBookingProvider(
      bookingType,
    );
  }

  @override
  AllBookingProvider getProviderOverride(
    covariant AllBookingProvider provider,
  ) {
    return call(
      provider.bookingType,
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
  String? get name => r'allBookingProvider';
}

/// See also [allBooking].
class AllBookingProvider extends AutoDisposeFutureProvider<List<BookingModel>> {
  /// See also [allBooking].
  AllBookingProvider(
    this.bookingType,
  ) : super.internal(
          (ref) => allBooking(
            ref,
            bookingType,
          ),
          from: allBookingProvider,
          name: r'allBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allBookingHash,
          dependencies: AllBookingFamily._dependencies,
          allTransitiveDependencies:
              AllBookingFamily._allTransitiveDependencies,
        );

  final String bookingType;

  @override
  bool operator ==(Object other) {
    return other is AllBookingProvider && other.bookingType == bookingType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingType.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$adminAllBookingHash() => r'63e10c8c20b81581f2ec52d69a10519a03cb7cb5';
typedef AdminAllBookingRef = AutoDisposeFutureProviderRef<List<BookingModel>>;

/// See also [adminAllBooking].
@ProviderFor(adminAllBooking)
const adminAllBookingProvider = AdminAllBookingFamily();

/// See also [adminAllBooking].
class AdminAllBookingFamily extends Family<AsyncValue<List<BookingModel>>> {
  /// See also [adminAllBooking].
  const AdminAllBookingFamily();

  /// See also [adminAllBooking].
  AdminAllBookingProvider call(
    String bookingType,
  ) {
    return AdminAllBookingProvider(
      bookingType,
    );
  }

  @override
  AdminAllBookingProvider getProviderOverride(
    covariant AdminAllBookingProvider provider,
  ) {
    return call(
      provider.bookingType,
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
  String? get name => r'adminAllBookingProvider';
}

/// See also [adminAllBooking].
class AdminAllBookingProvider
    extends AutoDisposeFutureProvider<List<BookingModel>> {
  /// See also [adminAllBooking].
  AdminAllBookingProvider(
    this.bookingType,
  ) : super.internal(
          (ref) => adminAllBooking(
            ref,
            bookingType,
          ),
          from: adminAllBookingProvider,
          name: r'adminAllBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminAllBookingHash,
          dependencies: AdminAllBookingFamily._dependencies,
          allTransitiveDependencies:
              AdminAllBookingFamily._allTransitiveDependencies,
        );

  final String bookingType;

  @override
  bool operator ==(Object other) {
    return other is AdminAllBookingProvider && other.bookingType == bookingType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingType.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
