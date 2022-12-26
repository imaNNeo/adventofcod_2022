import 'dart:io';

import 'package:adventofcode/utils/position.dart';

late int width;
late int height;

Future<String> solveDay24() async {
  final inputFile = File('lib/2022/day24/input.txt');
  final input = await inputFile.readAsString();
  return 'part1: ${part1(input)}, part2: ${part2(input)}';
}

int part1(String inputStr) {
  final input = _parseInput(inputStr);
  return _runTrip(input.blizzards, input.startPos, input.endPos);
}

int part2(String inputStr) {
  final input = _parseInput(inputStr);
  final startPos = input.startPos;
  final endPos = input.endPos;
  final blizzards = input.blizzards;
  final firstTrip = _runTrip(blizzards, startPos, endPos);
  final secondTrip = _runTrip(blizzards, endPos, startPos);
  final thirdTrip = _runTrip(blizzards, startPos, endPos);
  return firstTrip + secondTrip + thirdTrip;
}

int _runTrip(List<_Blizzard> blizzards, Position startPos, Position endPos) {
  int minutes = 0;
  Set<Position> blizzardPositions = {};
  Set<Position> pointers = {startPos};

  bool canMove(Position pos) {
    if (pos == endPos) {
      return true;
    }
    return pos.y > 0 && pos.y < height - 1 && pos.x > 0 && pos.x < width - 1;
  }

  while (!pointers.contains(endPos)) {
    for (final blizzard in blizzards) {
      blizzard.move();
    }
    blizzardPositions = blizzards.map((b) => b.pos).toSet();
    final Set<Position> newPointers = {};
    for (final pointer in pointers) {
      if (!blizzardPositions.contains(pointer) && pointer != startPos) {
        newPointers.add(pointer);
      }

      final left = pointer.left;
      if (canMove(left) && !blizzardPositions.contains(left)) {
        newPointers.add(left);
      }

      final top = pointer.top;
      if (canMove(top) && !blizzardPositions.contains(top)) {
        newPointers.add(top);
      }

      final right = pointer.right;
      if (canMove(right) && !blizzardPositions.contains(right)) {
        newPointers.add(right);
      }

      final bottom = pointer.bottom;
      if (canMove(bottom) && !blizzardPositions.contains(bottom)) {
        newPointers.add(bottom);
      }
    }

    // if there are no expeditions we must restart at the starting position
    if (newPointers.isEmpty) {
      newPointers.add(startPos);
    }
    pointers = newPointers;
    minutes++;
  }
  return minutes;
}

class _ParseResult {
  final List<_Blizzard> blizzards;
  final Position startPos;
  final Position endPos;
  _ParseResult(this.blizzards, this.startPos, this.endPos);
}

_ParseResult _parseInput(String input) {
  List<_Blizzard> blizzards = [];
  late Position startPos, endPos;

  final lines = input.split('\n');
  height = lines.length;
  width = lines.first.length;
  for (int y = 0; y < height; y++) {
    final line = lines[y];
    if (y == 0) {
      startPos = Position(line.indexOf('.'), 0);
    } else if (y == height - 1) {
      endPos = Position(line.indexOf('.', 0), height - 1);
    }
    for (int x = 0; x < width; x++) {
      final char = line[x];
      final pos = Position(x, y);
      if (char != '.' && char != '#') {
        blizzards.add(_Blizzard(pos, _Direction.parse(char)));
      }
    }
  }
  return _ParseResult(blizzards, startPos, endPos);
}

class _Blizzard {
  Position pos;
  final _Direction dir;

  _Blizzard(this.pos, this.dir);

  void move() {
    Position newPos = pos + dir.pos;
    if (newPos.x == 0) {
      newPos = pos.copyWith(x: width - 2);
    } else if (newPos.x == width - 1) {
      newPos = pos.copyWith(x: 1);
    } else if (newPos.y == 0) {
      newPos = pos.copyWith(y: height - 2);
    } else if (newPos.y == height - 1) {
      newPos = pos.copyWith(y: 1);
    }
    pos = newPos;
  }
}

enum _Direction {
  left(Position.leftDir),
  up(Position.topDir),
  right(Position.rightDir),
  down(Position.bottomDir);

  final Position pos;

  const _Direction(this.pos);

  String getChar() {
    switch (this) {
      case _Direction.left:
        return '<';
      case _Direction.up:
        return '^';
      case _Direction.right:
        return '>';
      case _Direction.down:
        return 'v';
      default:
        throw StateError('invalid');
    }
  }

  static _Direction parse(String dir) {
    switch (dir) {
      case '<':
        return left;
      case '^':
        return up;
      case '>':
        return right;
      case 'v':
        return down;
      default:
        throw StateError('invalid');
    }
  }
}