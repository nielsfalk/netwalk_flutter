import 'package:netwalk_flutter/cell.dart';
import 'package:netwalk_flutter/field.dart';

import 'package:test/test.dart';

void main() {


  var solvedFiled = new Field([
    [
      new Cell(server: true, right: true),
      new Cell(left: true, bottom: true, right: true),
      new Cell(left: true)
    ],
    [
      new Cell(),
      new Cell(top: true, right: true),
      new Cell(left: true)
    ]
  ]);

  test("field is solved", () {
    expect(
        new Field([
          [new Cell(top: true)]
        ]).solved,
        equals(false));
    expect(
        new Field([
          [new Cell()]
        ]).solved,
        equals(true));
    expect(
        new Field([
          [new Cell(top: true, on: true)]
        ]).solved,
        equals(true));

    solvedFiled.startServer();
    expect(solvedFiled.solved, equals(true));

    solvedFiled.rotate(1, 1, Rotation.right);
    solvedFiled.startServer();
    expect(solvedFiled.solved, equals(false));
  });

  test("count moves", () {
    expect(moveCount(Rotation.none), equals(0));
    expect(moveCount(Rotation.left), equals(1));
    expect(moveCount(Rotation.right), equals(1));
    expect(moveCount(Rotation.half), equals(2));
  });
}
