import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talenvo_collaborative_board/config/routes/app_routes.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/controllers/auth_controller.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/controllers/boards_controller.dart';

class BoardsDashboardPage extends StatelessWidget {
  const BoardsDashboardPage({super.key});

  Future<void> _openCreateBoardDialog(BuildContext context) async {
    final result = await showDialog<_CreateBoardInput>(
      context: context,
      builder: (_) => const _CreateBoardDialog(),
    );

    if (result == null || !context.mounted) {
      return;
    }

    await context.read<BoardsController>().createBoard(
      title: result.title,
      description: result.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthController>().logout();
              if (!context.mounted) {
                return;
              }
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateBoardDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Create board'),
      ),
      body: Consumer<BoardsController>(
        builder: (context, boardsController, _) {
          if (boardsController.isLoading && boardsController.boards.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (boardsController.errorMessage != null &&
              boardsController.boards.isEmpty) {
            return Center(child: Text(boardsController.errorMessage!));
          }

          if (boardsController.boards.isEmpty) {
            return RefreshIndicator(
              onRefresh: boardsController.refreshBoards,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Text('No boards yet. Create your first board.'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: boardsController.refreshBoards,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: boardsController.boards.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final board = boardsController.boards[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(board.name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(board.description),
                          const SizedBox(height: 4),
                          Text(
                            'Created: ${dateFormat.format(board.createdAt)}',
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Delete board',
                      onPressed: () => boardsController.deleteBoard(board.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.boardDetail(board.id));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CreateBoardInput {
  const _CreateBoardInput({required this.title, required this.description});

  final String title;
  final String description;
}

class _CreateBoardDialog extends StatefulWidget {
  const _CreateBoardDialog();

  @override
  State<_CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<_CreateBoardDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty) {
      return;
    }

    Navigator.of(
      context,
    ).pop(_CreateBoardInput(title: title, description: description));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Create board'),
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
        ],
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
