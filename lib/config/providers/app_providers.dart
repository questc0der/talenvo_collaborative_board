import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:talenvo_collaborative_board/core/services/token_storage.dart';
import 'package:talenvo_collaborative_board/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:talenvo_collaborative_board/features/auth/domain/repositories/auth_repository.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/controllers/auth_controller.dart';
import 'package:talenvo_collaborative_board/features/boards/data/repositories/in_memory_board_repository.dart';
import 'package:talenvo_collaborative_board/features/boards/domain/repositories/board_repository.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/controllers/boards_controller.dart';
import 'package:talenvo_collaborative_board/features/cards/data/repositories/in_memory_card_repository.dart';
import 'package:talenvo_collaborative_board/features/cards/domain/repositories/card_repository.dart';
import 'package:talenvo_collaborative_board/features/columns/data/repositories/in_memory_column_repository.dart';
import 'package:talenvo_collaborative_board/features/columns/domain/repositories/column_repository.dart';
import 'package:talenvo_collaborative_board/features/teammates/data/repositories/in_memory_teammate_repository.dart';
import 'package:talenvo_collaborative_board/features/teammates/domain/repositories/teammate_repository.dart';

class AppProviders {
  static Widget wrap(Widget child) {
    return MultiProvider(
      providers: [
        Provider<TokenStorage>(create: (_) => TokenStorage()),
        Provider<AuthRepository>(
          create: (context) =>
              InMemoryAuthRepository(context.read<TokenStorage>()),
        ),
        Provider<BoardRepository>(create: (_) => InMemoryBoardRepository()),
        Provider<ColumnRepository>(create: (_) => InMemoryColumnRepository()),
        Provider<CardRepository>(create: (_) => InMemoryCardRepository()),
        Provider<TeammateRepository>(
          create: (_) => InMemoryTeammateRepository(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) =>
              AuthController(context.read<AuthRepository>())..bootstrap(),
        ),
        ChangeNotifierProvider<BoardsController>(
          create: (context) =>
              BoardsController(context.read<BoardRepository>())..loadBoards(),
        ),
      ],
      child: child,
    );
  }
}
