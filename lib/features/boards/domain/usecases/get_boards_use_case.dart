import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';

class GetBoardsUseCase {
  const GetBoardsUseCase(this._boardRepository);

  final BoardRepository _boardRepository;

  Future<List<BoardEntity>> call() {
    return _boardRepository.getBoards();
  }
}
