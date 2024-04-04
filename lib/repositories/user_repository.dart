import 'package:guest_house_app/models/user_detail_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository();

class UserRepository {
  Future<List<UserDetailModel>> getUserbyId(String userId) async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return UserDetailModel.getUserById(userId);
      },
    );
  }

  Future<List<UserDetailModel>> getAllUser() async {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        return UserDetailModel.getAllUser();
      },
    );
  }
}
