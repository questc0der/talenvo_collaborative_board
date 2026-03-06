class BoardEntity {
  const BoardEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final int memberCount;
  final DateTime createdAt;
  final DateTime updatedAt;
}
