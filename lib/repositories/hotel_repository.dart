import 'package:guest_house_app/repositories/book_date.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/hotel_model.dart';

part 'hotel_repository.g.dart';

@riverpod
HotelRepository hotelRepository(HotelRepositoryRef ref) => HotelRepository();

class HotelRepository {
  Future<List<HotelModel>> getHotels() async {
    BookDates dates = await SharedPreferencesHelper.getBookingDates();
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String bookFrom = dates.bookFrom.isEmpty ? currentDate : dates.bookFrom;
    String bookTo = dates.bookTo.isEmpty ? currentDate : dates.bookTo;

    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return HotelModel.fetchHotels(bookFrom, bookTo);
      },
    );
  }

  Future<List<HotelModel>> getFavHotel() async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return HotelModel.fetchFavHotels();
      },
    );
  }

  Future<List<HotelModel>> reserveHotel(String houseId) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return HotelModel.reserveHotel(houseId);
      },
    );
  }

  Future<HotelModel> getHotel(String coffeeId) async {
    BookDates dates = await SharedPreferencesHelper.getBookingDates();

    final hotels = await HotelModel.fetchHotels(dates.bookFrom, dates.bookTo);
    return hotels.firstWhere((hotel) => hotel.id == coffeeId);
  }

  Future<List<HotelModel>> geAlltHotels() async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return HotelModel.fetchAllHotels();
      },
    );
  }
}
