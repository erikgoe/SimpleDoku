import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Board.dart';

class GameMenu extends StatefulWidget {
  final double fieldSize = 40;
  final Color borderColor = Colors.grey;

  @override
  State<StatefulWidget> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  Board board;
  Field focussed;
  bool win = false;
  bool finished = false;

  _GameMenuState() {
    createNewBoard();
  }

  void createNewBoard() {
    board = Board.modify(Random().nextInt(1 << 32));
  }

  void checkBoard() {
    if (!board.hasEmpty() || finished) {
      finished = true;
      if (board.checkBoard()) {
        setState(() {
          win = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              focussed = null;
            });
          },
        ),
        // Title
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(!win ? "SimpleDoku" : "Congratulations, you won!",
                style:
                    TextStyle(fontSize: 20, color: win ? Colors.green : null)),
          )
        ]),
        // Reload button
        (!win
            ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32, horizontal: 8),
                      child: IconButton(
                        icon: Icon(Icons.replay),
                        onPressed: () => setState(() {
                              createNewBoard();
                            }),
                      ))
                ],
              )
            : Container()),
        // Game board
        Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: board.fields
                    .map(
                      (list) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: list
                              .map(
                                (field) => Container(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (focussed == field ||
                                              field.initial)
                                            focussed = null;
                                          else
                                            focussed = field;
                                        });
                                      },
                                      child: Center(
                                          child: Text(
                                        field.number == null
                                            ? ""
                                            : field.number.toString(),
                                        style: TextStyle(
                                            color: field.initial
                                                ? Theme.of(context).primaryColor
                                                : null),
                                      )),
                                    ),
                                    width: widget.fieldSize,
                                    height: widget.fieldSize,
                                    decoration: BoxDecoration(
                                      color: () {
                                        if (focussed == field) {
                                          return Theme.of(context).primaryColor;
                                        } else {
                                          if (!field.valid) {
                                            if (field.initial) {
                                              return Colors.yellow;
                                            } else {
                                              return Colors.red;
                                            }
                                          } else
                                            return Colors.white.withAlpha(50);
                                        }
                                      }(),
                                      border: Border(
                                          left: BorderSide(
                                              color: widget.borderColor,
                                              width: field.x % 3 == 0 ? 2 : 0),
                                          right: BorderSide(
                                              color: widget.borderColor,
                                              width:
                                                  field.x == Board.boardBase - 1
                                                      ? 2
                                                      : 0),
                                          top: BorderSide(
                                              color: widget.borderColor,
                                              width: field.y % 3 == 0 ? 2 : 0),
                                          bottom: BorderSide(
                                              color: widget.borderColor,
                                              width:
                                                  field.y == Board.boardBase - 1
                                                      ? 2
                                                      : 0)),
                                    )),
                              )
                              .toList()),
                    )
                    .toList())),
        // Number pad
        (focussed != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1.6,
                            mainAxisSpacing: 1),
                        itemCount: Board.boardBase + 1,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: OutlineButton(
                              child: (i == Board.boardBase
                                  ? Icon(Icons.delete)
                                  : Text((i + 1).toString())),
                              onPressed: () {
                                setState(() {
                                  if (i == Board.boardBase)
                                    focussed.number = null;
                                  else
                                    focussed.number = i + 1;
                                  focussed = null;
                                  checkBoard();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ))
                  ])
            : Container()),
      ]),
    );
  }
}
