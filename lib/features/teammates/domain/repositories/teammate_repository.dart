import 'package:talenvo_collaborative_board/features/teammates/domain/entities/teammate_entity.dart';

abstract class TeammateRepository {
  Future<List<TeammateEntity>> getTeammates(String boardId);
}
