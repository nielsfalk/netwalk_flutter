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
        home: new Board(title: 'Netwal'),
      );
}

class Board extends StatefulWidget {
  Board({Key key, this.title}) : super(key: key);
  final String title;

  @override
  BoardState createState() => new BoardState();
}

class BoardState extends State<Board> {
  Field field =
      new Generator.generate(new Dimension(width: 4, height: 5)).field;

  void rotateRight(int row, int col) {
    setState(() {
      field.rotateRight(row, col);
      field.startServer();
    });
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

  Drawer drawer(BuildContext context) => new Drawer(
          child: new ListView(children: <Widget>[
        new DrawerHeader(
            child: new Text("Netwalk by Niels Falk - nielsfalk.de")),
        new ListTile(
            leading: new Icon(Icons.link), title: new Text("nielsfalk.de")),
        new ListTile(
            leading: new Icon(Icons.refresh),
            title: new Text("New Game"),
            onTap: () {
              Navigator.of(context).pop();
              newGame();
            }),
        new ListTile(
            leading: new Icon(Icons.more_horiz),
            title: new Row(children: <Widget>[
              new Text("height: "),
              new DropdownButton<int>(
                  value: field.dimension.height,
                  onChanged: (newValue) {
                    height(newValue);
                  },
                  items: <int>[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                      .map((value) => new DropdownMenuItem<int>(
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
                  items: <int>[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                      .map((value) => new DropdownMenuItem<int>(
                          value: value, child: new Text(value.toString())))
                      .toList())
            ])),
      ]));

  List<TableRow> createBoard() {
    List<TableRow> rows = [];
    for (var row = 0; row < field.dimension.height; row++) {
      List<Widget> cells = [];
      for (var col = 0; col < field.dimension.width; col++) {
        var cell = field.cells[row][col];
        var image = new Image.asset("assets/$cell.png");
        var it = new GestureDetector(
            onTap: () {
              rotateRight(row, col);
              print("foo $row $col");
            },
            onHorizontalDragUpdate: (details) {
              print('dragUpdate ${details.primaryDelta}');
            },
            child: image);
        cells.add(it);
      }
      rows.add(new TableRow(children: cells));
    }
    return rows;
  }
}
