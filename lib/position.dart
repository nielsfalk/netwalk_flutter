class Position {
  int row, col;

  Position({this.row, this.col});

  List<Position> neighbours(Dimension dimension) => [
        below(dimension),
        left(dimension),
        right(dimension),
        above(dimension),
      ];

  Position above(Dimension dimension) => new Position(
      row: (row + dimension.height - 1) % dimension.height, col: col);

  Position right(Dimension dimension) =>
      new Position(row: row, col: (col + 1) % dimension.width);

  Position left(Dimension dimension) =>
      new Position(row: row, col: (col + dimension.width - 1) % dimension.width);

  Position below(Dimension dimension) =>
      new Position(row:(row + 1) % dimension.height, col: col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Position &&
              runtimeType == other.runtimeType &&
              row == other.row &&
              col == other.col;

  @override
  int get hashCode =>
      row.hashCode ^
      col.hashCode;



}

class Dimension {
  int height, width;

  Dimension({this.height, this.width});
}
