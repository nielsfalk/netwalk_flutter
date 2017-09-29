import 'dart:math';

import 'package:netwalk_flutter/position.dart';

import 'cell.dart';

class Field {
  List<List<Cell>> cells;
  Dimension dimension;

  Field(this.cells) {
    dimension = new Dimension(
        height: cells.length, width: cells.isEmpty ? 0 : cells.first.length);
  }

  get solved => !allCells().any((cell) => cell.isOn == false);

  void rotateRight(int row, int col) {
    cells[row][col] = cells[row][col].rotateRight();
  }

  void startServer() {
    allCells().forEach((it)=>it.on=false);

    for (var row = 0; row < dimension.height; row++) {
      for (var col = 0; col < dimension.width; col++) {
        var position = new Position(row:row, col: col);
        var cell = getCell(position);
        if (cell.server){
          connect(position, cell,null);
        }
      }
    }
  }

  void connect(Position position, Cell cell, Cell before) {
    cell.on=true;
    if (cell.right){
      var neigbour = position.right(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.left && neigbourCell != before){
        connect(neigbour, neigbourCell, cell);
      }
    }

    if (cell.left){
      var neigbour = position.left(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.right && neigbourCell != before){
        connect(neigbour, neigbourCell, cell);
      }
    }

    if (cell.top){
      var neigbour = position.above(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.bottom && neigbourCell != before){
        connect(neigbour, neigbourCell, cell);
      }
    }

    if (cell.bottom){
      var neigbour = position.below(dimension);
      var neigbourCell = getCell(neigbour);
      if (neigbourCell.top && neigbourCell != before){
        connect(neigbour, neigbourCell, cell);
      }
    }
  }


  Cell getCell(Position position) =>
      cells[position.row][position.col];

  Iterable<Cell> allCells() => cells.expand((c) => c);

  void shuffle(Random random) {
    for (var row = 0; row < dimension.height; row++) {
      for (var col = 0; col < dimension.width; col++) {
        for (var cnt = 0; cnt < random.nextInt(4); cnt++) {
          rotateRight(row, col);
        }
      }
    }
  }
}
