import 'package:flutter/foundation.dart';
import 'package:talenvo_collaborative_board/features/auth/domain/entities/user_entity.dart';
import 'package:talenvo_collaborative_board/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._authRepository);

  final AuthRepository _authRepository;

  UserEntity? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;
  bool _bootstrapped = false;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;
  bool get isBootstrapped => _bootstrapped;

  Future<void> bootstrap() async {
    _setLoading(true);
    try {
      _token = await _authRepository.getSavedToken();
      if (_token != null) {
        _currentUser = const UserEntity(
          id: 'restored-user',
          name: 'Authenticated User',
          email: 'restored@session.local',
        );
      }
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _bootstrapped = true;
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      _token = result.$1;
      _currentUser = result.$2;
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final result = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      _token = result.$1;
      _currentUser = result.$2;
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
      _token = null;
      _currentUser = null;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();
    return message.replaceFirst('Exception: ', '');
  }
}
