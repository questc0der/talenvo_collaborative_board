import 'dart:math';

import 'package:talenvo_collaborative_board/core/services/token_storage.dart';
import 'package:talenvo_collaborative_board/features/auth/domain/entities/user_entity.dart';
import 'package:talenvo_collaborative_board/features/auth/domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository(this._tokenStorage);

  final TokenStorage _tokenStorage;

  static final Map<String, ({String name, String password})> _users = {
    'demo@talenvo.com': (name: 'Demo User', password: 'password123'),
  };

  @override
  Future<(String token, UserEntity user)> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final account = _users[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw Exception('Invalid email or password.');
    }

    final token = _generateJwtLikeToken();
    final user = UserEntity(
      id: 'user-${email.hashCode}',
      name: account.name,
      email: email,
    );
    await _tokenStorage.saveToken(token);
    return (token, user);
  }

  @override
  Future<(String token, UserEntity user)> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final normalized = email.trim().toLowerCase();
    if (_users.containsKey(normalized)) {
      throw Exception('Account already exists for this email.');
    }
    _users[normalized] = (name: name.trim(), password: password);

    final token = _generateJwtLikeToken();
    final user = UserEntity(
      id: 'user-${normalized.hashCode}',
      name: name.trim(),
      email: normalized,
    );
    await _tokenStorage.saveToken(token);
    return (token, user);
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearToken();
  }

  @override
  Future<String?> getSavedToken() {
    return _tokenStorage.readToken();
  }

  String _generateJwtLikeToken() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1 << 32);
    return 'eyJhbGciOiJIUzI1NiJ9.$now.$random';
  }
}
