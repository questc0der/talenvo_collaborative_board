import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class InMemoryCardRepository implements CardRepository {
  static final Map<String, List<CardEntity>> _cardsByColumn = {
    'col-1': [
      CardEntity(
        id: 'card-1',
        columnId: 'col-1',
        title: 'Define MVP features',
        description: 'Agree first release scope with team.',
        tags: ['MVP', 'Planning'],
        dueDate: DateTime(2026, 3, 10),
        assigneeName: 'Sam',
      ),
      CardEntity(
        id: 'card-2',
        columnId: 'col-1',
        title: 'Prepare onboarding flow',
        description: 'Draft screens and copy for new users.',
        tags: ['UX'],
        dueDate: DateTime(2026, 3, 12),
        assigneeName: 'Biruk',
      ),
    ],
    'col-2': [
      CardEntity(
        id: 'card-3',
        columnId: 'col-2',
        title: 'Implement board list page',
        description: 'Load boards and display state handling.',
        tags: ['Flutter', 'UI'],
        dueDate: DateTime(2026, 3, 14),
        assigneeName: 'Aster',
      ),
    ],
    'col-4': [
      CardEntity(
        id: 'card-4',
        columnId: 'col-4',
        title: 'Set up Flutter project',
        description: 'Initialize project and baseline tests.',
        tags: ['Setup'],
        dueDate: DateTime(2026, 3, 5),
        assigneeName: 'Noah',
      ),
    ],
  };

  @override
  Future<List<CardEntity>> getCards(String columnId) async {
    final cards = _cardsByColumn[columnId] ?? [];
    return List<CardEntity>.from(cards);
  }

  @override
  Future<CardEntity> createCard({
    required String columnId,
    required String title,
    String description = '',
    List<String> tags = const [],
    DateTime? dueDate,
  }) async {
    final existing = _cardsByColumn.putIfAbsent(columnId, () => []);
    final card = CardEntity(
      id: 'card-${DateTime.now().millisecondsSinceEpoch}',
      columnId: columnId,
      title: title,
      description: description,
      tags: tags,
      dueDate: dueDate,
    );
    existing.add(card);
    return card;
  }

  @override
  Future<CardEntity?> updateCard({
    required String cardId,
    required String columnId,
    required String title,
    required String description,
    required List<String> tags,
    required DateTime? dueDate,
  }) async {
    final cards = _cardsByColumn[columnId];
    if (cards == null) {
      return null;
    }

    final cardIndex = cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) {
      return null;
    }

    final current = cards[cardIndex];
    final updated = CardEntity(
      id: current.id,
      columnId: current.columnId,
      title: title,
      description: description,
      tags: tags,
      dueDate: dueDate,
      assigneeName: current.assigneeName,
    );
    cards[cardIndex] = updated;
    return updated;
  }

  @override
  Future<void> deleteCard({
    required String cardId,
    required String columnId,
  }) async {
    final cards = _cardsByColumn[columnId];
    cards?.removeWhere((card) => card.id == cardId);
  }

  @override
  Future<CardEntity?> moveCard({
    required String cardId,
    required String sourceColumnId,
    required String targetColumnId,
  }) async {
    if (sourceColumnId == targetColumnId) {
      return null;
    }

    final sourceCards = _cardsByColumn[sourceColumnId];
    if (sourceCards == null) {
      return null;
    }

    final cardIndex = sourceCards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) {
      return null;
    }

    final sourceCard = sourceCards.removeAt(cardIndex);
    final movedCard = CardEntity(
      id: sourceCard.id,
      columnId: targetColumnId,
      title: sourceCard.title,
      description: sourceCard.description,
      tags: sourceCard.tags,
      dueDate: sourceCard.dueDate,
      assigneeName: sourceCard.assigneeName,
    );

    final targetCards = _cardsByColumn.putIfAbsent(targetColumnId, () => []);
    targetCards.add(movedCard);

    return movedCard;
  }

  @override
  Future<CardEntity?> assignCard({
    required String cardId,
    required String columnId,
    required String? assigneeName,
  }) async {
    final cards = _cardsByColumn[columnId];
    if (cards == null) {
      return null;
    }

    final cardIndex = cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) {
      return null;
    }

    final current = cards[cardIndex];
    final updated = CardEntity(
      id: current.id,
      columnId: current.columnId,
      title: current.title,
      description: current.description,
      tags: current.tags,
      dueDate: current.dueDate,
      assigneeName: assigneeName,
    );
    cards[cardIndex] = updated;
    return updated;
  }
}
