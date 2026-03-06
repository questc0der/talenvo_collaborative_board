import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';

abstract class CardRepository {
  Future<List<CardEntity>> getCards(String columnId);
  Future<CardEntity> createCard({
    required String columnId,
    required String title,
    String description,
    List<String> tags,
    DateTime? dueDate,
  });
  Future<CardEntity?> updateCard({
    required String cardId,
    required String columnId,
    required String title,
    required String description,
    required List<String> tags,
    required DateTime? dueDate,
  });
  Future<void> deleteCard({required String cardId, required String columnId});
  Future<CardEntity?> moveCard({
    required String cardId,
    required String sourceColumnId,
    required String targetColumnId,
  });
  Future<CardEntity?> assignCard({
    required String cardId,
    required String columnId,
    required String? assigneeName,
  });
}
