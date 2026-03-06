import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';

class InMemoryColumnRepository implements ColumnRepository {
  static final Map<String, List<ColumnEntity>> _columnsByBoard = {
    'board-1': [
      const ColumnEntity(
        id: 'col-1',
        boardId: 'board-1',
        name: 'Backlog',
        position: 0,
      ),
      const ColumnEntity(
        id: 'col-2',
        boardId: 'board-1',
        name: 'Doing',
        position: 1,
      ),
      const ColumnEntity(
        id: 'col-3',
        boardId: 'board-1',
        name: 'Review',
        position: 2,
      ),
      const ColumnEntity(
        id: 'col-4',
        boardId: 'board-1',
        name: 'Done',
        position: 3,
      ),
    ],
    'board-2': [
      const ColumnEntity(
        id: 'col-5',
        boardId: 'board-2',
        name: 'Ideas',
        position: 0,
      ),
      const ColumnEntity(
        id: 'col-6',
        boardId: 'board-2',
        name: 'Planned',
        position: 1,
      ),
    ],
    'board-3': [
      const ColumnEntity(
        id: 'col-7',
        boardId: 'board-3',
        name: 'New',
        position: 0,
      ),
      const ColumnEntity(
        id: 'col-8',
        boardId: 'board-3',
        name: 'Triaged',
        position: 1,
      ),
      const ColumnEntity(
        id: 'col-9',
        boardId: 'board-3',
        name: 'Resolved',
        position: 2,
      ),
    ],
  };

  @override
  Future<List<ColumnEntity>> getColumns(String boardId) async {
    final columns = _columnsByBoard[boardId] ?? [];
    return columns..sort((a, b) => a.position.compareTo(b.position));
  }

  @override
  Future<ColumnEntity> createColumn({
    required String boardId,
    required String name,
  }) async {
    final existing = _columnsByBoard.putIfAbsent(boardId, () => []);
    final column = ColumnEntity(
      id: 'col-${DateTime.now().millisecondsSinceEpoch}',
      boardId: boardId,
      name: name,
      position: existing.length,
    );
    existing.add(column);
    return column;
  }
}
