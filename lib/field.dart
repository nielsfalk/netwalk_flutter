import 'dart:math';

import 'package:netwalk_flutter/position.dart';

import 'cell.dart';

class Field {
  List<List<Cell>> cells;
  Dimension dimension;
  int shuffleRotations = 0;
  int rotationsMade = 0;

  Field(this.cells) {
    dimension = new Dimension(
        height: cells.length, width: cells.isEmpty ? 0 : cells.first.length);
  }

  get solved => !allCells().any((cell) => cell.isOn == false);

  void rotate(int row, int col, Rotation rotation) {
    rotationsMade += moveCount(rotation);
    for (var i = 0; i < rotation.index; ++i) {
      cells[row][col] = cells[row][col].rotateRight();
    }
  }

  void startServer() {
    allCells().forEach((it) => it.on = false);

    for (var row = 0; row < dimension.height; row++) {
      for (var col = 0; col < dimension.width; col++) {
        var position = new Position(row: row, col: col);
        var cell = getCell(position);
        if (cell.server) {
          connect(position, cell, null, []);
        }
      }
    }
  }

  void connect(Position position, Cell cell, Cell before,
      List<Cell> alreadyConnected) {
    if (alreadyConnected.contains(cell)) {
      return;
    }
    cell.on = true;
    alreadyConnected.add(cell);
    if (cell.right) {
      var neigbour = position.right(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.left && neigbourCell != before) {
        connect(neigbour, neigbourCell, cell, alreadyConnected);
      }
    }

    if (cell.left) {
      var neigbour = position.left(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.right && neigbourCell != before) {
        connect(neigbour, neigbourCell, cell, alreadyConnected);
      }
    }

    if (cell.top) {
      var neigbour = position.above(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.bottom && neigbourCell != before) {
        connect(neigbour, neigbourCell, cell, alreadyConnected);
      }
    }

    if (cell.bottom) {
      var neigbour = position.below(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.top && neigbourCell != before) {
        connect(neigbour, neigbourCell, cell, alreadyConnected);
      }
    }
  }

  Cell getCell(Position position) => cells[position.row][position.col];

  Iterable<Cell> allCells() => cells.expand((c) => c);

  void shuffle(Random random) {
    for (var row = 0; row < dimension.height; row++) {
      for (var col = 0; col < dimension.width; col++) {
        var rotation = Rotation.values[random.nextInt(Rotation.values.length)];
        rotate(row, col, rotation);
      }
    }
    shuffleRotations = rotationsMade;
    rotationsMade = 0;
  }
}

int moveCount(Rotation rotation) =>
    rotation == Rotation.left ? 1 : rotation.index;

enum Rotation { none, right, half, left }
