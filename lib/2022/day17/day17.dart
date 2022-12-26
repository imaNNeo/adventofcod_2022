import 'dart:io';
import 'dart:math';

import 'package:adventofcode/utils/collection.dart';
import 'package:adventofcode/utils/position.dart';

Future<String> solveDay17() async {
  final inputFile = File('lib/2022/day17/input.txt');
  final input = await inputFile.readAsString();

  return ''
      'part1: ${_getHighestValue(maxSettleCount: 2022, input: input)}, '
      'part2: ${_getHighestValue(maxSettleCount: 1000000000000, input: input)}';
}

Shape _generateNewShape(int shapeTurn, int highest) {
  int initialX = 2;
  int initialY = highest - 3;
  Shape shape = Shape(Shape.shapes[shapeTurn % 5]);
  shape.position = Position(initialX, initialY - shape.height);
  return shape;
}

bool _canShapeGoRight(Shape shape, Map<Position, String> map) {
  if (shape.position.x + shape.width >= 7) {
    return false;
  }

  for (int localX = shape.width - 1; localX >= 0; localX--) {
    for (int localY = 0; localY < shape.height; localY++) {
      final rightWorldPos = Position(
        shape.position.x + localX,
        shape.position.y + localY,
      ).right;

      final char = shape.shape[localY][localX];
      if (char == '@' &&
          map.containsKey(rightWorldPos) &&
          map[rightWorldPos]! == '#') {
        return false;
      }
    }
  }

  return true;
}

bool _canShapeGoLeft(Shape shape, Map<Position, String> map) {
  if (shape.position.x <= 0) {
    return false;
  }

  for (int localX = 0; localX < shape.width; localX++) {
    for (int localY = 0; localY < shape.height; localY++) {
      final leftWorldPos = Position(
        shape.position.x + localX,
        shape.position.y + localY,
      ).left;

      final char = shape.shape[localY][localX];
      if (char == '@' &&
          map.containsKey(leftWorldPos) &&
          map[leftWorldPos]! == '#') {
        return false;
      }
    }
  }

  return true;
}

bool _canShapeGoBottom(Shape shape, Map<Position, String> map) {
  if (shape.position.y + shape.height >= 0) {
    return false;
  }
  for (int localY = shape.height - 1; localY >= 0; localY--) {
    final row = shape.shape[localY];
    for (int localX = 0; localX < row.length; localX++) {
      final char = row[localX];
      final bottomWorldPos = Position(
        shape.position.x + localX,
        shape.position.y + localY,
      ).bottom;
      if (char == '@' &&
          map.containsKey(bottomWorldPos) &&
          map[bottomWorldPos]! == '#') {
        return false;
      }
    }
  }
  return true;
}

int _settleShape(Shape shape, Map<Position, String> map) {
  int highest = 0;
  for (int y = 0; y < shape.height; y++) {
    for (int x = 0; x < shape.width; x++) {
      final char = shape.shape[y][x];
      final worldPos = Position(
        shape.position.x + x,
        shape.position.y + y,
      );
      if (char == '@') {
        highest = min(highest, worldPos.y);
      }

      String currentChar = map.getOrElse(worldPos, '.');
      if (currentChar != '#') {
        map[worldPos] = char == '@' ? '#' : '.';
      }
    }
  }
  return highest;
}

int _getHighestValue({
  required int maxSettleCount,
  required String input,
}) {
  final int groundY = 0;
  Map<Position, String> map = {};
  int shapeTurn = 0;
  int highest = groundY;

  Shape shape = _generateNewShape(shapeTurn, highest);
  int i = -1;
  int settledCount = 0;
  int cyclePoint = input.length * Shape.shapes.length;

  int prevCycleI = 0;
  int prevCycleHighest = 0;
  int prevCycleSettleCount = 0;
  while (true) {
    i++;
    final arrow = input[i % input.length];
    if (arrow == '<') {
      // move left
      if (_canShapeGoLeft(shape, map)) {
        shape.position = shape.position.left;
      }
    } else if (arrow == '>') {
      //move right
      if (_canShapeGoRight(shape, map)) {
        shape.position = shape.position.right;
      }
    } else {
      throw StateError('Invalid input "$arrow"');
    }
    //move bottom
    if (_canShapeGoBottom(shape, map)) {
      shape.position = shape.position.bottom;
    } else {
      highest = min(_settleShape(shape, map), highest);
      shapeTurn++;
      settledCount++;
      if (settledCount == maxSettleCount) {
        break;
      }
      shape = _generateNewShape(shapeTurn, highest);
      // _printWorldState(shape, highest, map);
    }
    if (i % cyclePoint == 0) {
      int cycleNumber = i ~/ cyclePoint;
      if (cycleNumber == 2) {
        int settleCountInThisCycle = settledCount - prevCycleSettleCount;
        int highestInThisCycle = highest - prevCycleHighest;
        int iCountInThisCycle = i - prevCycleI;
        int multiplyFactor = (maxSettleCount - settledCount) ~/ settleCountInThisCycle;

        // If maxSettleCount is a high value, then we multiply with multiplyFactor.
        if (multiplyFactor > 2) {
          i += (iCountInThisCycle * multiplyFactor);
          settledCount += (settleCountInThisCycle * multiplyFactor);
          final addingHighest = (highestInThisCycle * multiplyFactor);
          int newHighest = highest + addingHighest;
          shape.position = shape.position.copyWith(y: shape.position.y + addingHighest);
          // Copy previous highest 10 rows state
          for (int y = 0; y <= 20; y++) {
            for (int x = 0; x < 7; x++) {
              final prevPos = Position(x, highest + y);
              final newPos = Position(x, newHighest + y);
              if (map.containsKey(prevPos)) {
                map[newPos] = map[prevPos]!;
              }
            }
          }
          highest = newHighest;
        }
      }
      prevCycleSettleCount = settledCount;
      prevCycleHighest = highest;
      prevCycleI = i;
    }
  }
  return highest.abs();
}

void _printWorldState(
    Shape currentShape, int highest, Map<Position, String> map) {
  int startY = min(highest, currentShape.position.y);
  int endY = startY + 10;
  for (int y = startY; y <= endY; y++) {
    stdout.write('$y ->    ');
    for (int x = -1; x <= 7; x++) {
      if (x == -1 || x == 7) {
        if (y == 0) {
          stdout.write(' + ');
        } else {
          stdout.write(' | ');
        }
        continue;
      }
      if (y == 0) {
        stdout.write(' - ');
        continue;
      }
      final pos = Position(x, y);
      if (currentShape.contains(pos)) {
        final localPos = pos - currentShape.position;
        stdout.write(' ${currentShape.shape[localPos.y][localPos.x]} ');
      } else {
        if (map.containsKey(pos)) {
          stdout.write(' ${map[pos]} ');
        } else {
          stdout.write(' . ');
        }
      }
    }
    stdout.write('\n');
  }
  print('\n');
}

class Shape {
  static const shapes = [
    [
      ['@', '@', '@', '@']
    ],
    [
      ['.', '@', '.'],
      ['@', '@', '@'],
      ['.', '@', '.'],
    ],
    [
      ['.', '.', '@'],
      ['.', '.', '@'],
      ['@', '@', '@'],
    ],
    [
      ['@'],
      ['@'],
      ['@'],
      ['@'],
    ],
    [
      ['@', '@'],
      ['@', '@'],
    ],
  ];

  int get width => shape.first.length;

  int get height => shape.length;

  bool contains(Position pos) {
    if (pos.x < position.x) {
      return false;
    }
    if (pos.x > position.x + width - 1) {
      return false;
    }
    if (pos.y < position.y) {
      return false;
    }
    if (pos.y > position.y + height - 1) {
      return false;
    }
    return true;
  }

  late Position position;
  final List<List<String>> shape;

  Shape(this.shape);
}
