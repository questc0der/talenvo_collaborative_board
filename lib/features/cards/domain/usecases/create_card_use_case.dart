import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';

class CreateCardUseCase {
  const CreateCardUseCase(this._cardRepository);

  final CardRepository _cardRepository;

  Future<CardEntity> call({
    required String columnId,
    required String title,
    String description = '',
    List<String> tags = const [],
    DateTime? dueDate,
  }) {
    return _cardRepository.createCard(
      columnId: columnId,
      title: title,
      description: description,
      tags: tags,
      dueDate: dueDate,
    );
  }
}
