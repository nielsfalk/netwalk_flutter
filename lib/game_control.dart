import 'field.dart';
import 'field_generator.dart';
import 'main.dart';
import 'position.dart';

class GameControl {
  BoardState boardState;
  Field field =
      new Generator.generate(new Dimension(width: 4, height: 5)).field;

  GameControl(this.boardState);

  void rotateCell(int row, int col) {
    boardState.setState(() {
      field.rotateRight(row, col);
      field.startServer();
    });
    if (field.solved) {
      boardState.wonMessage();
    }
  }

  void height(int newVal) {
    if (newVal != null) {
      boardState.setState(() {
        field = new Generator.generate(
                new Dimension(width: field.dimension.width, height: newVal))
            .field;
      });
    }
  }

  void width(int newVal) {
    if (newVal != null) {
      boardState.setState(() {
        field = new Generator.generate(
                new Dimension(width: newVal, height: field.dimension.height))
            .field;
      });
    }
  }

  void newGame() {
    boardState.setState(() {
      field = new Generator.generate(new Dimension(
              height: field.dimension.height, width: field.dimension.width))
          .field;
    });
  }

  bool anyCellLocked() => field.allCells().any((it) => it.locked);

  unlockAllCells() => field.allCells().forEach((it) => it.locked = false);
}
