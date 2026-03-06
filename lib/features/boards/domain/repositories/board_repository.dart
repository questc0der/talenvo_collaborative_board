import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';

abstract class BoardRepository {
  Future<List<BoardEntity>> getBoards();
  Future<BoardEntity?> getBoardById(String boardId);
  Future<BoardEntity> createBoard({
    required String title,
    required String description,
  });
  Future<void> deleteBoard(String boardId);
}
