import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/features/boards/UI/widgets/board_widget.dart';

void main() {
  runApp(const MyApp());
}

@Preview(name: "Home Page")
Widget homePagePreview() {
  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const Board(),
    );
  }
}
