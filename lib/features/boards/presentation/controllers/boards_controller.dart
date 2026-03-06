import 'package:flutter/foundation.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';

class BoardsController extends ChangeNotifier {
  BoardsController(this._boardRepository);

  final BoardRepository _boardRepository;

  List<BoardEntity> _boards = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BoardEntity> get boards => _boards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBoards() async {
    _setLoading(true);
    try {
      _boards = await _boardRepository.getBoards();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshBoards() async {
    try {
      _boards = await _boardRepository.getBoards();
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = _cleanError(error);
      notifyListeners();
    }
  }

  Future<bool> createBoard({
    required String title,
    required String description,
  }) async {
    _setLoading(true);
    try {
      await _boardRepository.createBoard(
        title: title,
        description: description,
      );
      _boards = await _boardRepository.getBoards();
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBoard(String boardId) async {
    _setLoading(true);
    try {
      await _boardRepository.deleteBoard(boardId);
      _boards = await _boardRepository.getBoards();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _setLoading(false);
    }
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
