import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';

class InMemoryBoardRepository implements BoardRepository {
  static final List<BoardEntity> _boards = [
    BoardEntity(
      id: 'board-1',
      name: 'Product Roadmap',
      description: 'Weekly planning for product delivery.',
      memberCount: 5,
      createdAt: DateTime(2026, 1, 5),
      updatedAt: DateTime(2026, 3, 2),
    ),
    BoardEntity(
      id: 'board-2',
      name: 'Marketing Sprint',
      description: 'Campaign ideas and approvals for social channels.',
      memberCount: 4,
      createdAt: DateTime(2026, 1, 12),
      updatedAt: DateTime(2026, 3, 1),
    ),
    BoardEntity(
      id: 'board-3',
      name: 'Bug Triage',
      description: 'Incoming issues triage for mobile releases.',
      memberCount: 6,
      createdAt: DateTime(2026, 2, 2),
      updatedAt: DateTime(2026, 2, 28),
    ),
  ];

  @override
  Future<List<BoardEntity>> getBoards() async {
    return List<BoardEntity>.from(_boards);
  }

  @override
  Future<BoardEntity?> getBoardById(String boardId) async {
    for (final board in _boards) {
      if (board.id == boardId) {
        return board;
      }
    }
    return null;
  }

  @override
  Future<BoardEntity> createBoard({
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    final board = BoardEntity(
      id: 'board-${now.millisecondsSinceEpoch}',
      name: title,
      description: description,
      memberCount: 1,
      createdAt: now,
      updatedAt: now,
    );
    _boards.insert(0, board);
    return board;
  }

  @override
  Future<void> deleteBoard(String boardId) async {
    _boards.removeWhere((board) => board.id == boardId);
  }
}
