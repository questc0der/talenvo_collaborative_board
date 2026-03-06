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
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _CreateColumnDialog(),
    );

    if (name == null || !context.mounted) {
      return;
    }

    await context.read<BoardDetailController>().createColumn(
      boardId: board.id,
      name: name,
    );
  }

  Future<void> _showUpsertCardDialog(
    BuildContext context,
    ColumnEntity column, {
    CardEntity? existing,
  }) async {
    final input = await showDialog<_UpsertCardInput>(
      context: context,
      builder: (_) => _UpsertCardDialog(existing: existing),
    );

    if (input == null || !context.mounted) {
      return;
    }

    final controller = context.read<BoardDetailController>();
    if (existing == null) {
      await controller.createCard(
        boardId: board.id,
        columnId: column.id,
        title: input.title,
        description: input.description,
        tags: input.tags,
        dueDate: input.dueDate,
      );
    } else {
      await controller.editCard(
        boardId: board.id,
        cardId: existing.id,
        columnId: column.id,
        title: input.title,
        description: input.description,
        tags: input.tags,
        dueDate: input.dueDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');

    return Scaffold(
      resizeToAvoidBottomInset: false,
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

class _CreateColumnDialog extends StatefulWidget {
  const _CreateColumnDialog();

  @override
  State<_CreateColumnDialog> createState() => _CreateColumnDialogState();
}

class _CreateColumnDialogState extends State<_CreateColumnDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Create column'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Column name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}

class _UpsertCardInput {
  const _UpsertCardInput({
    required this.title,
    required this.description,
    required this.tags,
    required this.dueDate,
  });

  final String title;
  final String description;
  final List<String> tags;
  final DateTime? dueDate;
}

class _UpsertCardDialog extends StatefulWidget {
  const _UpsertCardDialog({this.existing});

  final CardEntity? existing;

  @override
  State<_UpsertCardDialog> createState() => _UpsertCardDialogState();
}

class _UpsertCardDialogState extends State<_UpsertCardDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;
  late final TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existing?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existing?.description ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.existing?.tags.join(', ') ?? '',
    );
    _dueDateController = TextEditingController(
      text: widget.existing?.dueDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.existing!.dueDate!)
          : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final dueDateText = _dueDateController.text.trim();
    final dueDate = dueDateText.isEmpty ? null : DateTime.tryParse(dueDateText);
    final tags = _tagsController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    Navigator.of(context).pop(
      _UpsertCardInput(
        title: title,
        description: _descriptionController.text.trim(),
        tags: tags,
        dueDate: dueDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCreate = widget.existing == null;

    return AlertDialog(
      scrollable: true,
      title: Text(isCreate ? 'Create card' : 'Edit card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags (comma separated)',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _dueDateController,
            decoration: const InputDecoration(
              labelText: 'Due date (YYYY-MM-DD)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isCreate ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}
