import 'package:flutter/material.dart';
import 'game_control.dart';
import 'drag_rotation.dart';

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


class BoardState extends State<Board> {

  GameControl game;
  DragRotation dragRotation;

  BoardState() {
    game = new GameControl(this);
    dragRotation = new DragRotation(this, game);
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
            game.newGame();
          })
    ];
    if (game.anyCellLocked()) {
      items.add(new ListTile(
          leading: new Icon(Icons.lock_open),
          title: new Text("Unlock all"),
          onTap: () {
            Navigator.of(context).pop();
            setState(() => game.unlockAllCells());
          }));
    }
    items.addAll([
      new ListTile(
          leading: new Icon(Icons.more_horiz),
          title: new Row(children: <Widget>[
            new Text("height: "),
            new DropdownButton<int>(
                value: game.field.dimension.height,
                onChanged: (newValue) {
                  game.height(newValue);
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
                value: game.field.dimension.width,
                onChanged: (newValue) {
                  game.width(newValue);
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
    for (var row = 0; row < game.field.dimension.height; row++) {
      List<Widget> cells = [];
      for (var col = 0; col < game.field.dimension.width; col++) {
        var cell = game.field.cells[row][col];
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
            title: new Text('You have won!', style: dialogTextStyle),
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
                    game.newGame();
                  })
            ]));
  }
}
