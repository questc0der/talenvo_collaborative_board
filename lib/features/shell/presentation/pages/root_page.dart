import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/controllers/auth_controller.dart';
import 'package:talenvo_collaborative_board/features/auth/presentation/pages/login_page.dart';
import 'package:talenvo_collaborative_board/features/boards/presentation/pages/boards_dashboard_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (!auth.isBootstrapped || auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.isAuthenticated) {
          return const BoardsDashboardPage();
        }

        return const LoginPage();
      },
    );
  }
}
