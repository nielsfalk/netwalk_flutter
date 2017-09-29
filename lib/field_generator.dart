import 'dart:math';

import 'cell.dart';
import 'field.dart';
import 'position.dart';

class Generator {
  Field field;
  List<List<ConstructionCell>> cells = [];
  Random random = new Random();
  Dimension dimension;

  Generator.generate(this.dimension) {
    for (var row = 0; row < dimension.height; row++) {
      List<ConstructionCell> cells = [];
      for (var col = 0; col < dimension.width; col++) {
        cells.add(new ConstructionCell(new Position(row: row, col: col)));
      }
      this.cells.add(cells);
    }
    createCells(
        from: cells[random.nextInt(dimension.height)]
            [random.nextInt(dimension.width)],
        server: true);
    wireCells();
    field =
        new Field(cells.map((it) => it.map((it) => it.cell).toList()).toList());
    field.shuffle(random);
    field.startServer();
  }

  //for test only
  Generator({this.dimension}) {
    for (var row = 0; row < dimension.height; row++) {
      List<ConstructionCell> cells = [];
      for (var col = 0; col < dimension.width; col++) {
        cells.add(new ConstructionCell(new Position(row: row, col: col)));
      }
      this.cells.add(cells);
    }
  }

  void createCells(
      {ConstructionCell from, bool server = false, ConstructionCell parent}) {
    from.cell = new Cell(server: server);
    from.parent = parent;
    var neighbours = from.position
        .neighbours(dimension)
        .map((position) => getCell(position))
        .toList();
    neighbours.shuffle(random);
    neighbours.forEach((it) {
      if (it.cell == null) {
        createCells(from: it, parent: from);
      }
    });
  }

  ConstructionCell getCell(Position position) =>
      cells[position.row][position.col];

  void wireCells() {
    var expand = cells.expand((cell) => cell);
    expand.forEach((cell) {
      if (cell == left(cell).parent || cell.parent == left(cell)) {
        cell.cell.left = true;
      }
      if (cell == right(cell).parent || cell.parent == right(cell)) {
        cell.cell.right = true;
      }
      if (cell == below(cell).parent || cell.parent == below(cell)) {
        cell.cell.bottom = true;
      }
      if (cell == above(cell).parent || cell.parent == above(cell)) {
        cell.cell.top = true;
      }
    });
  }

  ConstructionCell left(ConstructionCell cell) =>
      getCell(cell.position.left(dimension));

  ConstructionCell right(ConstructionCell cell) =>
      getCell(cell.position.right(dimension));

  ConstructionCell below(ConstructionCell cell) =>
      getCell(cell.position.below(dimension));

  ConstructionCell above(ConstructionCell cell) =>
      getCell(cell.position.above(dimension));
}

class ConstructionCell {
  Cell cell;
  Position position;

  ConstructionCell parent;

  ConstructionCell(this.position);
}
