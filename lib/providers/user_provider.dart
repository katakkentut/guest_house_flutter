import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:guest_house_app/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Future<List<UserDetailModel>> userById(UserByIdRef ref, String userId) async {
  print('user by id');
  final UserRepository userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserbyId(userId);
}

@riverpod
Future<List<UserDetailModel>> allUsers(UserByIdRef ref) async {
  print('all users');
  final UserRepository userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getAllUser();
}
