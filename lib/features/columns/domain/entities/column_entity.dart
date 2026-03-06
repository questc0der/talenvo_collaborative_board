class ColumnEntity {
  const ColumnEntity({
    required this.id,
    required this.boardId,
    required this.name,
    required this.position,
  });

  final String id;
  final String boardId;
  final String name;
  final int position;
}
