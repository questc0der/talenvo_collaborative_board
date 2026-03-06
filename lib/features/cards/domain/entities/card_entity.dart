class CardEntity {
  const CardEntity({
    required this.id,
    required this.columnId,
    required this.title,
    required this.description,
    required this.tags,
    required this.dueDate,
    this.assigneeName,
  });

  final String id;
  final String columnId;
  final String title;
  final String description;
  final List<String> tags;
  final DateTime? dueDate;
  final String? assigneeName;
}
