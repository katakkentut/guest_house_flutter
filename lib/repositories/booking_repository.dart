import 'package:guest_house_app/models/booking_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_repository.g.dart';

@riverpod
BookingRepository bookingRepository(BookingRepositoryRef ref) =>
    BookingRepository();

class BookingRepository {
  Future<List<BookingModel>> getBooking(String bookType) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return BookingModel.getBooking(bookType);
      },
    );
  }

  Future<List<BookingModel>> getAllBooking(String bookType) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return BookingModel.getAllBooking(bookType);
      },
    );
  }
}
