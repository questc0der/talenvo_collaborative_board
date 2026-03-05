class BoardEntity {
  const BoardEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final int memberCount;
  final DateTime updatedAt;
}
