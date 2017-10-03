import 'dart:math';

import 'cell.dart';
import 'field.dart';
import 'position.dart';

class Generator {
  Field field;
  List<List<ConstructionCell>> cells = [];
  Random random = new Random();
  Dimension dimension;
  List<ConstructionCell> generateNext;

  Generator.generate(this.dimension) {
    for (var row = 0; row < dimension.height; row++) {
      List<ConstructionCell> cells = [];
      for (var col = 0; col < dimension.width; col++) {
        cells.add(new ConstructionCell(new Position(row: row, col: col)));
      }
      this.cells.add(cells);
    }
    generateNext = [];
    createCell(
        from: cells[random.nextInt(dimension.height)]
            [random.nextInt(dimension.width)],
        server: true);
    generatePendingCells();
    wireCells();
    field =
    new Field(cells.map((it) => it.map((it) => it.cell).toList()).toList())
      ..shuffle(random)
      ..startServer();
  }

  void createCell({ConstructionCell from, bool server = false}) {
    generateNext.remove(from);
    from.cell = new Cell(server: server);
    var neighbours = from.position
        .neighbours(dimension)
        .map((position) => getCell(position))
        .where((it) => it.cell == null && !generateNext.contains(it))
        .toList();

    switch (neighbours.length) {
      case 1:
        schedule(neighbours, from);
        break;
      case 2:
        schedule(neighbours.sublist(random.nextInt(1)), from);
        break;
      case 3:
      case 4: //the server
        if (random.nextInt(100) == 1) {
          schedule(neighbours, from);
        } else {
          neighbours.shuffle(random);
          var maximumCount = neighbours.length - 1;
          schedule(
              neighbours.sublist(random.nextInt(maximumCount), maximumCount),
              from);
        }
        break;
    }
  }

  void schedule(List<ConstructionCell> cells, ConstructionCell parent) {
    cells.forEach((it) {
      it.parent = parent;
      generateNext.add(it);
    });
  }

  void generatePendingCells() {
    while (generateNext.length > 0) {
      var next = generateNext[random.nextInt(generateNext.length)];
      createCell(from: next);
    }
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
