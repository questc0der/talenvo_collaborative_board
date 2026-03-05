import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';

class InMemoryBoardRepository implements BoardRepository {
  @override
  Future<List<BoardEntity>> getBoards() async {
    return [
      BoardEntity(
        id: 'board-1',
        name: 'Product Roadmap',
        description: 'Weekly planning for product delivery.',
        memberCount: 5,
        updatedAt: DateTime(2026, 3, 2),
      ),
      BoardEntity(
        id: 'board-2',
        name: 'Marketing Sprint',
        description: 'Campaign ideas and approvals for social channels.',
        memberCount: 4,
        updatedAt: DateTime(2026, 3, 1),
      ),
      BoardEntity(
        id: 'board-3',
        name: 'Bug Triage',
        description: 'Incoming issues triage for mobile releases.',
        memberCount: 6,
        updatedAt: DateTime(2026, 2, 28),
      ),
    ];
  }
}
