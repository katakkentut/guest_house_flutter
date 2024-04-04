import 'package:guest_house_app/models/booking_model.dart';
import 'package:guest_house_app/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'all_booking_provider.g.dart';

@riverpod
Future<List<BookingModel>> allBooking(AllBookingRef ref, String bookingType) async {
  print('allHotels');
  final BookingRepository bookingRepository = ref.watch(bookingRepositoryProvider);
  return bookingRepository.getBooking(bookingType);
}

@riverpod
Future<List<BookingModel>> adminAllBooking(AllBookingRef ref, String bookingType) async {
  print('admin all hotels');
  final BookingRepository bookingRepository = ref.watch(bookingRepositoryProvider);
  return bookingRepository.getAllBooking(bookingType);
}


