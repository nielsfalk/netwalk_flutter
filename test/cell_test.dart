import 'package:netwalk_flutter/cell.dart';
import 'package:test/test.dart';

Map<Cell, Cell> equalsTestData = new Map.from({
  new Cell(): new Cell(),
  new Cell(top: true): new Cell(top: true),
});

Map<Cell, String> toStringTestDate = new Map.from({
  new Cell(): "Off",
  new Cell(left: true, right: true, bottom: true, top: true, server: true):
      "ServerOnLeftRightBottomTop",
});

Map<Cell, Cell> rotateTestData = new Map.from({
  new Cell(left: true): new Cell(top: true),
  new Cell(top: true): new Cell(right: true),
  new Cell(right: true): new Cell(bottom: true),
  new Cell(bottom: true): new Cell(left: true),
});

void main() {
  equalsTestData.forEach((actual, expectToEqual) {
    test("$actual==$expectToEqual", () {
      expect(actual, equals(expectToEqual));
    });
  });

  toStringTestDate.forEach((actual, expectedToString) {
    test("$actual toString", () {
      expect(actual.toString(), equals(expectedToString));
    });
  });

  rotateTestData.forEach((actual, expected) {
    test("$actual rotate to $expected", () {
      expect(actual.rotateRight(), equals(expected));
    });
  });
}
