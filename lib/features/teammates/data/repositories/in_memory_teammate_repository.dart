import 'package:talenvo_collaborative_board/features/teammates/domain/entities/teammate_entity.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/repositories/teammate_repository.dart';

class InMemoryTeammateRepository implements TeammateRepository {
  static const Map<String, List<TeammateEntity>> _teammatesByBoard = {
    'board-1': [
      TeammateEntity(id: 'tm-1', name: 'Biruk'),
      TeammateEntity(id: 'tm-2', name: 'Sam'),
      TeammateEntity(id: 'tm-3', name: 'Aster'),
      TeammateEntity(id: 'tm-4', name: 'Noah'),
      TeammateEntity(id: 'tm-5', name: 'Mia'),
    ],
    'board-2': [
      TeammateEntity(id: 'tm-6', name: 'Liya'),
      TeammateEntity(id: 'tm-7', name: 'Dani'),
      TeammateEntity(id: 'tm-8', name: 'Ruth'),
    ],
    'board-3': [
      TeammateEntity(id: 'tm-9', name: 'Ken'),
      TeammateEntity(id: 'tm-10', name: 'Nora'),
    ],
  };

  @override
  Future<List<TeammateEntity>> getTeammates(String boardId) async {
    return _teammatesByBoard[boardId] ?? const [];
  }
}
