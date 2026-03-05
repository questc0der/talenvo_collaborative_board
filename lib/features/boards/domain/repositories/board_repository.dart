import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';

abstract class BoardRepository {
  Future<List<BoardEntity>> getBoards();
}
