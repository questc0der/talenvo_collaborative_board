import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/features/cards/UI/widgets/card_widget.dart';

class BoardColumn extends StatefulWidget {
  const BoardColumn({super.key});

  @override
  State<BoardColumn> createState() => _ColumnState();
}

@Preview(name: "Column Widget")
Widget columnWidgetPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Column(children: const [BoardCard(), BoardCard()])),
  );
}

class _ColumnState extends State<BoardColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(children: const [BoardCard(), BoardCard()]);
  }
}
