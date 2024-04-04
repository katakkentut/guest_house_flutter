import 'package:guest_house_app/models/service_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_repository.g.dart';

@riverpod
ServiceRepository serviceRepository(ServiceRepositoryRef ref) =>
    ServiceRepository();

class ServiceRepository {
  Future<List<ServiceModel>> getService(String reservationId) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return ServiceModel.getService(reservationId);
      },
    );
  }

  Future<List<ServiceModel>> adminGetService(String serviceStatus) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return ServiceModel.adminGetService(serviceStatus);
      },
    );
  }
}
