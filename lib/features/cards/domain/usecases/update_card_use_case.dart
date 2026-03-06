import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class UpdateCardUseCase {
  const UpdateCardUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<CardEntity?> call({
    required String cardId,
    required String columnId,
    required String title,
    required String description,
    required List<String> tags,
    required DateTime? dueDate,
  }) {
    return _cardRepository.updateCard(
      cardId: cardId,
      columnId: columnId,
      title: title,
      description: description,
      tags: tags,
      dueDate: dueDate,
    );
  }
}
