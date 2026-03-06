import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/controllers/board_detail_controller.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/entities/card_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';

class BoardDetailPage extends StatelessWidget {
  const BoardDetailPage({required this.board, super.key});

  final BoardEntity board;

  Future<void> _showCreateColumnDialog(BuildContext context) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create column'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Column name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    final name = controller.text.trim();
    controller.dispose();

    if (confirmed == true && name.isNotEmpty && context.mounted) {
      await context.read<BoardDetailController>().createColumn(
        boardId: board.id,
        name: name,
      );
    }
  }

  Future<void> _showUpsertCardDialog(
    BuildContext context,
    ColumnEntity column, {
    CardEntity? existing,
  }) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    final tagsController = TextEditingController(
      text: existing?.tags.join(', ') ?? '',
    );
    final dueDateController = TextEditingController(
      text: existing?.dueDate != null
          ? DateFormat('yyyy-MM-dd').format(existing!.dueDate!)
          : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Create card' : 'Edit card'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Due date (YYYY-MM-DD)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(existing == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final tags = tagsController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    final dueDateText = dueDateController.text.trim();

    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    dueDateController.dispose();

    if (confirmed != true || title.isEmpty || !context.mounted) {
      return;
    }

    final dueDate = dueDateText.isEmpty ? null : DateTime.tryParse(dueDateText);

    final controller = context.read<BoardDetailController>();
    if (existing == null) {
      await controller.createCard(
        boardId: board.id,
        columnId: column.id,
        title: title,
        description: description,
        tags: tags,
        dueDate: dueDate,
      );
    } else {
      await controller.editCard(
        boardId: board.id,
        cardId: existing.id,
        columnId: column.id,
        title: title,
        description: description,
        tags: tags,
        dueDate: dueDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');

    return Scaffold(
      appBar: AppBar(
        title: Text(board.name),
        actions: [
          TextButton.icon(
            onPressed: () => _showCreateColumnDialog(context),
            icon: const Icon(Icons.view_column),
            label: const Text('Create column'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<BoardDetailController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.columns.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null && controller.columns.isEmpty) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.columns.isEmpty) {
            return const Center(child: Text('No columns yet.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.columns.map((column) {
                final cards = controller.cardsByColumn[column.id] ?? const [];

                return Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  column.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Create card',
                                onPressed: () =>
                                    _showUpsertCardDialog(context, column),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          if (cards.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('No cards in this column.'),
                            )
                          else
                            ...cards.map(
                              (card) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(card.description),
                                    const SizedBox(height: 6),
                                    if (card.tags.isNotEmpty)
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: card.tags
                                            .map(
                                              (tag) => Chip(label: Text(tag)),
                                            )
                                            .toList(),
                                      ),
                                    if (card.dueDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          'Due: ${dateFormat.format(card.dueDate!)}',
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Assignee: ${card.assigneeName ?? 'Unassigned'}',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButton<String?>(
                                            isExpanded: true,
                                            value: card.assigneeName,
                                            hint: const Text('Assign teammate'),
                                            items: [
                                              const DropdownMenuItem<String?>(
                                                value: null,
                                                child: Text('Unassigned'),
                                              ),
                                              ...controller.teammates.map(
                                                (teammate) =>
                                                    DropdownMenuItem<String?>(
                                                      value: teammate.name,
                                                      child: Text(
                                                        teammate.name,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              controller.assignCard(
                                                boardId: board.id,
                                                cardId: card.id,
                                                columnId: column.id,
                                                assigneeName: value,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _showUpsertCardDialog(
                                                context,
                                                column,
                                                existing: card,
                                              ),
                                          child: const Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.deleteCard(
                                              boardId: board.id,
                                              cardId: card.id,
                                              columnId: column.id,
                                            );
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
