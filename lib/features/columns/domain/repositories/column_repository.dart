import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';

abstract class ColumnRepository {
  Future<List<ColumnEntity>> getColumns(String boardId);
  Future<ColumnEntity> createColumn({
    required String boardId,
    required String name,
  });
}
