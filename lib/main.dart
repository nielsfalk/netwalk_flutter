import 'package:flutter/material.dart';

import 'field.dart';
import 'field_generator.dart';
import 'position.dart';

void main() {
  runApp(new NetwalkApp());
}

class NetwalkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
        title: 'Netwalk',
        theme: new ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: new Board(title: 'Netwalk'),
      );
}

class Board extends StatefulWidget {
  Board({Key key, this.title}) : super(key: key);
  final String title;

  @override
  BoardState createState() => new BoardState();
}

class DragRotation {
  BoardState boardState;
  double dragWidth = 0.0;
  int dragRow;
  int dragCol;

  DragRotation(this.boardState);

  void update(int row, int col, double delta) {
    if (boardState.field.cells[row][col].locked) {
      return;
    }
    dragRow = row;
    dragCol = col;
    boardState.setState(() {
      dragWidth += delta;
    });
  }

  void finished() {
    if (dragCol == null || dragRow == null) {
      return;
    }
    while (dragWidth < 0) {
      dragWidth += 360;
    }
    var spins = (dragWidth / 90).round() % 4;
    boardState.setState(() {
      for (var i = 0; i < spins; ++i) {
        boardState.rotateCell(dragRow, dragCol);
      }
      dragRow = null;
      dragCol = null;
      dragWidth = 0.0;
    });
  }

  double current(int row, int col) {
    return (row == dragRow && col == dragCol) ? dragWidth : 0.0;
  }
}

class BoardState extends State<Board> {
  Field field =
      new Generator.generate(new Dimension(width: 4, height: 5)).field;
  DragRotation dragRotation;

  BoardState() {
    dragRotation = new DragRotation(this);
  }

  void rotateCell(int row, int col) {
    setState(() {
      field.rotateRight(row, col);
      field.startServer();
    });
    if (field.solved) {
      wonMessage();
    }
  }

  void height(int newVal) {
    if (newVal != null) {
      setState(() {
        field = new Generator.generate(
                new Dimension(width: field.dimension.width, height: newVal))
            .field;
      });
    }
  }

  void width(int newVal) {
    if (newVal != null) {
      setState(() {
        field = new Generator.generate(
                new Dimension(width: newVal, height: field.dimension.height))
            .field;
      });
    }
  }

  void newGame() {
    setState(() {
      field = new Generator.generate(new Dimension(
              height: field.dimension.height, width: field.dimension.width))
          .field;
    });
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
      drawer: drawer(context),
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Table(
          border: new TableBorder.all(),
          children: createBoard(),
        ),
      ));

  Drawer drawer(BuildContext context) {
    List<Widget> items = [
      new DrawerHeader(child: new Text("Netwalk by Niels Falk - nielsfalk.de")),
      new ListTile(
          leading: new Icon(Icons.link), title: new Text("nielsfalk.de")),
      new ListTile(
          leading: new Icon(Icons.refresh),
          title: new Text("New Game"),
          onTap: () {
            Navigator.of(context).pop();
            newGame();
          })
    ];
    if (field.allCells().any((it) => it.locked)) {
      items.add(new ListTile(
          leading: new Icon(Icons.lock_open),
          title: new Text("Unlock all"),
          onTap: () {
            Navigator.of(context).pop();
            setState(() => field.allCells().forEach((it) => it.locked = false));
          }));
    }
    items.addAll([
      new ListTile(
          leading: new Icon(Icons.more_horiz),
          title: new Row(children: <Widget>[
            new Text("height: "),
            new DropdownButton<int>(
                value: field.dimension.height,
                onChanged: (newValue) {
                  height(newValue);
                },
                items: <int>[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                    .map((value) =>
                new DropdownMenuItem<int>(
                    value: value, child: new Text(value.toString())))
                    .toList())
          ])),
      new ListTile(
          leading: new Icon(Icons.more_vert),
          title: new Row(children: <Widget>[
            new Text("width: "),
            new DropdownButton<int>(
                value: field.dimension.width,
                onChanged: (newValue) {
                  width(newValue);
                },
                items: <int>[3, 4, 5, 6, 7, 8]
                    .map((value) =>
                new DropdownMenuItem<int>(
                    value: value, child: new Text(value.toString())))
                    .toList())
          ]))
    ]);
    return new Drawer(child: new ListView(children: items));
  }

  List<TableRow> createBoard() {
    List<TableRow> rows = [];
    for (var row = 0; row < field.dimension.height; row++) {
      List<Widget> cells = [];
      for (var col = 0; col < field.dimension.width; col++) {
        var cell = field.cells[row][col];
        var image = new Image.asset("assets/$cell.png");
        var container = new Container(
            color: cell.locked ? Colors.teal.shade100 : null, child: image);
        var rotatedImage = new RotationTransition(
          turns:
          new AlwaysStoppedAnimation(dragRotation.current(row, col) / 360),
          child: container,
        );
        var it = new GestureDetector(
            onTap: () {
              setState(() {
                cell.locked = !cell.locked;
              });
            },
            onVerticalDragUpdate: (it) {
              dragRotation.update(row, col, it.delta.dy);
            },
            onHorizontalDragUpdate: (it) =>
                dragRotation.update(row, col, it.delta.dx),
            onVerticalDragEnd: (it) => dragRotation.finished(),
            onHorizontalDragEnd: (it) => dragRotation.finished(),
            child: rotatedImage);
        cells.add(it);
      }
      rows.add(new TableRow(children: cells));
    }
    return rows;
  }

  wonMessage() {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    showDialog(
        context: context,
        child: new AlertDialog(
            title: new Text('You have won', style: dialogTextStyle),
            content: new Text('Play again?', style: dialogTextStyle),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    newGame();
                  })
            ]));
  }
}
