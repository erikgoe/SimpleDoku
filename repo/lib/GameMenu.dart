import 'package:flutter/material.dart';

import 'Board.dart';

class GameMenu extends StatefulWidget {
  final double fieldSize = 20;

  @override
  State<StatefulWidget> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  var board = Board.generate(1);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children: board.fields
                .map(
                  (list) => Row(
                      children: list
                          .map(
                            (field) => Container(
                                width: widget.fieldSize,
                                height: widget.fieldSize,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                )),
                          )
                          .toList()),
                )
                .toList()));
  }
}
