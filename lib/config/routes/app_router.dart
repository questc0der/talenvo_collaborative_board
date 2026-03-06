import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/config/routes/app_routes.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/pages/login_page.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/pages/register_page.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/pages/board_detail_shell_page.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/pages/boards_dashboard_page.dart';
import 'package:talenvo_collaborative_board/features/shell/presentation/pages/root_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? AppRoutes.root;

    if (routeName == AppRoutes.root) {
      return _material(const RootPage(), settings);
    }
    if (routeName == AppRoutes.login) {
      return _material(const LoginPage(), settings);
    }
    if (routeName == AppRoutes.register) {
      return _material(const RegisterPage(), settings);
    }
    if (routeName == AppRoutes.boards) {
      return _material(const BoardsDashboardPage(), settings);
    }

    final uri = Uri.parse(routeName);
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'boards') {
      final boardId = uri.pathSegments[1];
      return _material(BoardDetailShellPage(boardId: boardId), settings);
    }

    return _material(
      const Scaffold(body: Center(child: Text('Route not found'))),
      settings,
    );
  }

  static MaterialPageRoute<dynamic> _material(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
