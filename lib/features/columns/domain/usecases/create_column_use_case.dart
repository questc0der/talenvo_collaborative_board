import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';

class CreateColumnUseCase {
  const CreateColumnUseCase(this._columnRepository);

  final ColumnRepository _columnRepository;

  Future<ColumnEntity> call({required String boardId, required String name}) {
    return _columnRepository.createColumn(boardId: boardId, name: name);
  }
}
