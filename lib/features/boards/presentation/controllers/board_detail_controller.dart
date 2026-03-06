import 'package:flutter/foundation.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/entities/teammate_entity.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/repositories/teammate_repository.dart';

class BoardDetailController extends ChangeNotifier {
  BoardDetailController(
    this._columnRepository,
    this._cardRepository,
    this._teammateRepository,
  );

  final ColumnRepository _columnRepository;
  final CardRepository _cardRepository;
  final TeammateRepository _teammateRepository;

  List<ColumnEntity> _columns = const [];
  Map<String, List<CardEntity>> _cardsByColumn = const {};
  List<TeammateEntity> _teammates = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ColumnEntity> get columns => _columns;
  Map<String, List<CardEntity>> get cardsByColumn => _cardsByColumn;
  List<TeammateEntity> get teammates => _teammates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBoard(String boardId) async {
    _setLoading(true);
    try {
      _columns = await _columnRepository.getColumns(boardId);
      _teammates = await _teammateRepository.getTeammates(boardId);
      final next = <String, List<CardEntity>>{};
      for (final column in _columns) {
        next[column.id] = await _cardRepository.getCards(column.id);
      }
      _cardsByColumn = next;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createColumn({
    required String boardId,
    required String name,
  }) async {
    _setLoading(true);
    try {
      await _columnRepository.createColumn(boardId: boardId, name: name);
      await loadBoard(boardId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createCard({
    required String boardId,
    required String columnId,
    required String title,
    required String description,
    required List<String> tags,
    required DateTime? dueDate,
  }) async {
    _setLoading(true);
    try {
      await _cardRepository.createCard(
        columnId: columnId,
        title: title,
        description: description,
        tags: tags,
        dueDate: dueDate,
      );
      await loadBoard(boardId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editCard({
    required String boardId,
    required String cardId,
    required String columnId,
    required String title,
    required String description,
    required List<String> tags,
    required DateTime? dueDate,
  }) async {
    _setLoading(true);
    try {
      await _cardRepository.updateCard(
        cardId: cardId,
        columnId: columnId,
        title: title,
        description: description,
        tags: tags,
        dueDate: dueDate,
      );
      await loadBoard(boardId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCard({
    required String boardId,
    required String cardId,
    required String columnId,
  }) async {
    _setLoading(true);
    try {
      await _cardRepository.deleteCard(cardId: cardId, columnId: columnId);
      await loadBoard(boardId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> assignCard({
    required String boardId,
    required String cardId,
    required String columnId,
    required String? assigneeName,
  }) async {
    _setLoading(true);
    try {
      await _cardRepository.assignCard(
        cardId: cardId,
        columnId: columnId,
        assigneeName: assigneeName,
      );
      await loadBoard(boardId);
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
