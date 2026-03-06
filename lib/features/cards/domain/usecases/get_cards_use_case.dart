import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class GetCardsUseCase {
  const GetCardsUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<List<CardEntity>> call(String columnId) {
    return _cardRepository.getCards(columnId);
  }
}
