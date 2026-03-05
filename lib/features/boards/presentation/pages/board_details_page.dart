import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/data/repositories/in_memory_column_repository.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/entities/column_entity.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/usecases/create_column_use_case.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/usecases/get_columns_use_case.dart';

class BoardDetailsPage extends StatefulWidget {
  const BoardDetailsPage({required this.board, super.key});

  final BoardEntity board;

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  final InMemoryColumnRepository _columnRepository = InMemoryColumnRepository();

  late final GetColumnsUseCase _getColumnsUseCase;
  late final CreateColumnUseCase _createColumnUseCase;

  List<ColumnEntity> _columns = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getColumnsUseCase = GetColumnsUseCase(_columnRepository);
    _createColumnUseCase = CreateColumnUseCase(_columnRepository);
    _loadColumns();
  }

  Future<void> _loadColumns() async {
    final columns = await _getColumnsUseCase(widget.board.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _columns = columns;
      _isLoading = false;
    });
  }

  Future<void> _createColumn() async {
    var draftName = '';

    final columnName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create column'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => draftName = value,
            decoration: const InputDecoration(hintText: 'Column name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(draftName.trim()),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    final name = columnName?.trim() ?? '';
    if (name.isEmpty) {
      return;
    }

    await _createColumnUseCase(boardId: widget.board.id, name: name);
    await _loadColumns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.board.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createColumn,
        icon: const Icon(Icons.add),
        label: const Text('Create column'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _columns.isEmpty
          ? const Center(child: Text('No columns yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _columns.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final column = _columns[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${column.position + 1}'),
                    ),
                    title: Text(column.name),
                    subtitle: Text('Column in ${widget.board.name}'),
                  ),
                );
              },
            ),
    );
  }
}
