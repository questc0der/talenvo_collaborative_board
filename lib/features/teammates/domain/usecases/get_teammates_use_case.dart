import 'package:talenvo_collaborative_board/features/teammates/domain/entities/teammate_entity.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/repositories/teammate_repository.dart';

class GetTeammatesUseCase {
  const GetTeammatesUseCase(this._teammateRepository);

  final TeammateRepository _teammateRepository;

  Future<List<TeammateEntity>> call(String boardId) {
    return _teammateRepository.getTeammates(boardId);
  }
}
