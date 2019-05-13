import 'package:SimpleDoku/PredefinedBoards.dart';

class Board {
  static final int boardBase = 9;
  static final int boardBaseBlock = 3;
  List<List<Field>> fields;

  Board.modify(int number, int seed) {
    clear();
    var toCopy = PredefinedBoards.boards[number].fields;
    for (int y = 0; y < boardBase; y++) {
      for (int x = 0; x < boardBase; x++) {
        fields[y][x] = Field.of(toCopy[y][x]);
      }
    }

    shuffle(seed);
  }

  Board.of(List<Field> fields) {
    clear();
    fields.forEach((f) {
      var field = this.fields[f.y][f.x];
      field.number = f.number;
      field.initial = true;
    });
  }

  clear() {
    fields = List<List<Field>>();
    for (int y = 0; y < boardBase; y++) {
      var innerList = List<Field>();
      for (int x = 0; x < boardBase; x++) {
        innerList.add(Field(x, y));
      }
      fields.add(innerList);
    }
  }

  bool hasEmpty() {
    for (int y = 0; y < boardBase; y++)
      for (int x = 0; x < boardBase; x++)
        if (fields[y][x].number == null) return true;
    return false;
  }

  // returns true when the board has be solved
  bool checkBoard() {
    bool ret = true;
    for (int y = 0; y < boardBase; y++) {
      for (int x = 0; x < boardBase; x++) {
        int number = fields[y][x].number;
        if (number == null) {
          fields[y][x].valid = true;
          continue;
        }

        int countRow = 0, countColumn = 0, countBlock = 0;

        for (int i = 0; i < boardBase; i++) {
          if (fields[y][i].number == number) countRow++;
        }
        for (int i = 0; i < boardBase; i++) {
          if (fields[i][x].number == number) countColumn++;
        }

        int blockOffsetX = x ~/ boardBaseBlock,
            blockOffsetY = y ~/ boardBaseBlock;
        for (int y2 = 0; y2 < boardBaseBlock; y2++) {
          for (int x2 = 0; x2 < boardBaseBlock; x2++) {
            if (fields[blockOffsetY * boardBaseBlock + y2]
                        [blockOffsetX * boardBaseBlock + x2]
                    .number ==
                number) countBlock++;
          }
        }

        bool valid = countRow == 1 && countColumn == 1 && countBlock == 1;
        fields[y][x].valid = valid;
        if (!valid) ret = false;
      }
    }
    return ret;
  }

  void shuffle(int seed) {
    swapColumnBlock(0, 1);

    updateIndices();
  }

  void swapRowBlock(int first, int second) {
    var swapList = List<Field>();

    // store first & overwrite
    for (int y = 0; y < boardBaseBlock; y++) {
      for (int x = 0; x < boardBase; x++) {
        swapList.add(fields[y + first * boardBaseBlock][x]);
        fields[y + first * boardBaseBlock][x] =
            fields[y + second * boardBaseBlock][x];
      }
    }

    // store second
    for (int y = 0; y < boardBaseBlock; y++) {
      for (int x = 0; x < boardBase; x++) {
        fields[y + second * boardBaseBlock][x] =
            swapList[y * boardBase + x];
      }
    }
  }

  void swapColumnBlock(int first, int second) {
    var swapList = List<Field>();

    // store first & overwrite
    for (int y = 0; y < boardBase; y++) {
      for (int x = 0; x < boardBaseBlock; x++) {
        swapList.add(fields[y][x + first * boardBaseBlock]);
        fields[y][x + first * boardBaseBlock] =
            fields[y][x + second * boardBaseBlock];
      }
    }

    // store second
    for (int y = 0; y < boardBase; y++) {
      for (int x = 0; x < boardBaseBlock; x++) {
        fields[y][x + second * boardBaseBlock] =
            swapList[y * boardBaseBlock + x];
      }
    }
  }

  void updateIndices() {
    for (int y = 0; y < boardBase; y++) {
      for (int x = 0; x < boardBase; x++) {
        fields[y][x].x = x;
        fields[y][x].y = y;
      }
    }
  }
}

class Field {
  int x, y;
  int number;
  bool initial;
  bool valid = true;

  Field(this.x, this.y, {this.number, this.initial = false});
  Field.of(Field other) {
    this.x = other.x;
    this.y = other.y;
    this.number = other.number;
    this.initial = other.initial;
    this.valid = other.valid;
  }
}
