import 'game_control.dart';
import 'main.dart';
import 'field.dart';

class DragRotation {
  BoardState boardState;
  GameControl gameControl;
  double dragWidth = 0.0;
  int dragRow;
  int dragCol;

  DragRotation(this.boardState, this.gameControl);

  void update(int row, int col, double delta) {
    if (gameControl.field.cells[row][col].locked) {
      return;
    }
    dragRow = row;
    dragCol = col;
    boardState.setState(() {
      dragWidth += delta;
    });
  }

  void finished() {
    if (dragCol == null || dragRow == null) {
      return;
    }
    while (dragWidth < 0) {
      dragWidth += 360;
    }
    var rotation = Rotation.values[(dragWidth / 90).round() % 4];
    boardState.setState(() {
      gameControl.rotateCell(dragRow, dragCol, rotation);
      dragRow = null;
      dragCol = null;
      dragWidth = 0.0;
    });
  }

  double current(int row, int col) {
    return (row == dragRow && col == dragCol) ? dragWidth : 0.0;
  }
}
