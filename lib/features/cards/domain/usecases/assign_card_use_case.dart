import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class AssignCardUseCase {
  const AssignCardUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<CardEntity?> call({
    required String cardId,
    required String columnId,
    required String? assigneeName,
  }) {
    return _cardRepository.assignCard(
      cardId: cardId,
      columnId: columnId,
      assigneeName: assigneeName,
    );
  }
}
