import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/repositories/service_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_provider.g.dart';

@riverpod
Future<List<ServiceModel>> allService(AllServiceRef ref, String reservationId) async {
  print('user service');
  final ServiceRepository serviceRepository = ref.watch(serviceRepositoryProvider);
  return serviceRepository.getService(reservationId);
}


@riverpod
Future<List<ServiceModel>> admminAllService(AllServiceRef ref, String serviceStatus) async {
  print('all service');
  final ServiceRepository serviceRepository = ref.watch(serviceRepositoryProvider);
  return serviceRepository.adminGetService(serviceStatus);
}

