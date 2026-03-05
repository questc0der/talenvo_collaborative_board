import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/features/boards/data/repositories/in_memory_board_repository.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/entities/board_entity.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/usecases/get_boards_use_case.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/pages/board_details_page.dart';

class BoardsPage extends StatelessWidget {
  BoardsPage({super.key});

  final GetBoardsUseCase _getBoardsUseCase = GetBoardsUseCase(
    InMemoryBoardRepository(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boards')),
      body: FutureBuilder<List<BoardEntity>>(
        future: _getBoardsUseCase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Failed to load boards: ${snapshot.error}'),
              ),
            );
          }

          final boards = snapshot.data ?? [];
          if (boards.isEmpty) {
            return const Center(child: Text('No boards found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: boards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final board = boards[index];
              return Card(
                child: ListTile(
                  title: Text(board.name),
                  subtitle: Text(board.description),
                  trailing: Text('${board.memberCount} members'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BoardDetailsPage(board: board),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
