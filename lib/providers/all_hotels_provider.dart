import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/hotel_model.dart';
import '../repositories/hotel_repository.dart';

part 'all_hotels_provider.g.dart';

@riverpod
Future<List<HotelModel>> allHotels(AllHotelsRef ref) async {
  print('allHotels');
  final HotelRepository hotelRepository = ref.watch(hotelRepositoryProvider);
  return hotelRepository.getHotels();
}

@riverpod
Future<List<HotelModel>> adminAllHotels(AllHotelsRef ref) async {
  print('allHotels');
  final HotelRepository hotelRepository = ref.watch(hotelRepositoryProvider);
  return hotelRepository.geAlltHotels();
}

@riverpod
Future<List<HotelModel>> favHotels(AllHotelsRef ref) async {
  print('favHotels');
  final HotelRepository hotelRepository = ref.watch(hotelRepositoryProvider);
  return hotelRepository.getFavHotel();
}

@riverpod
Future<List<HotelModel>> selectedHotel(AllHotelsRef ref, String houseId) async {
  print('selectedHotel');
  final HotelRepository hotelRepository = ref.watch(hotelRepositoryProvider);
  return hotelRepository.reserveHotel(houseId);
}
