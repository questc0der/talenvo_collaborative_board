import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class DeleteCardUseCase {
  const DeleteCardUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<void> call({required String cardId, required String columnId}) {
    return _cardRepository.deleteCard(cardId: cardId, columnId: columnId);
  }
}
