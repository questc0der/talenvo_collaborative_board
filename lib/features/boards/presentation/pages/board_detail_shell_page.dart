import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/controllers/board_detail_controller.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/pages/board_detail_page.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/repositories/teammate_repository.dart';

class BoardDetailShellPage extends StatelessWidget {
  const BoardDetailShellPage({required this.boardId, super.key});

  final String boardId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<BoardRepository>().getBoardById(boardId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final board = snapshot.data;
        if (board == null) {
          return const Scaffold(body: Center(child: Text('Board not found')));
        }

        return ChangeNotifierProvider(
          create: (_) => BoardDetailController(
            context.read<ColumnRepository>(),
            context.read<CardRepository>(),
            context.read<TeammateRepository>(),
          )..loadBoard(boardId),
          child: BoardDetailPage(board: board),
        );
      },
    );
  }
}
