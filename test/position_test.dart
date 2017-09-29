import 'package:test/test.dart';
import 'package:netwalk_flutter/position.dart';

void main() {
  test("neigbours", () {
    var dimension = new Dimension(height: 10, width: 5);
    var position = new Position(row:6, col: 3);

    var above = position.above(dimension);
    expect(above, equals(new Position(row: 5, col: 3)));

    var below = position.below(dimension);
    expect(below, equals(new Position(row: 7, col: 3)));

    var right = position.right(dimension);
    expect(right, equals(new Position(row: 6,col: 4)));

    var left = position.left(dimension);
    expect(left, equals(new Position(row: 6,col: 2)));
  });
}
