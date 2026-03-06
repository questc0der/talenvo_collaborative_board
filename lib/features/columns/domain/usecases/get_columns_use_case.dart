import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';

class GetColumnsUseCase {
  const GetColumnsUseCase(this._columnRepository);

  final ColumnRepository _columnRepository;

  Future<List<ColumnEntity>> call(String boardId) {
    return _columnRepository.getColumns(boardId);
  }
}
