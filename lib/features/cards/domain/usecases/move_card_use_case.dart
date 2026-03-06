import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class MoveCardUseCase {
  const MoveCardUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<CardEntity?> call({
    required String cardId,
    required String sourceColumnId,
    required String targetColumnId,
  }) {
    return _cardRepository.moveCard(
      cardId: cardId,
      sourceColumnId: sourceColumnId,
      targetColumnId: targetColumnId,
    );
  }
}
