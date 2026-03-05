import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';

class BoardCard extends StatefulWidget {
  const BoardCard({super.key});

  @override
  State<BoardCard> createState() => _BoardCardState();
}

@Preview(name: "Card Widget")
Widget cardWidgetPreview() {
  return Card(
    child: Column(children: [Text("title"), Text("Description"), Text("Tag")]),
  );
}

class _BoardCardState extends State<BoardCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Text("title"), Text("Description"), Text("Tag")],
      ),
    );
  }
}
