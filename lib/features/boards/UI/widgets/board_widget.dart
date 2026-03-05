import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:talenvo_collaborative_board/features/columns/UI/widgets/column_widget.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

@Preview(name: "Board Widget")
Widget boardWidgetPreview() {
  return MaterialApp(
    home: Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: BoardColumn(),
          ),
        ),
      ),
    ),
  );
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: BoardColumn(),
            ),
          ),
        ),
      ),
    );
  }
}
