import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/config/providers/app_providers.dart';
import 'package:talenvo_collaborative_board/config/routes/app_router.dart';
import 'package:talenvo_collaborative_board/config/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrap(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Talenvo Collaborative Board',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.root,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
