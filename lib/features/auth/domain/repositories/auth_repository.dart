import 'package:talenvo_collaborative_board/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<(String token, UserEntity user)> login({
    required String email,
    required String password,
  });

  Future<(String token, UserEntity user)> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
  Future<String?> getSavedToken();
}
