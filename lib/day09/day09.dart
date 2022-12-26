import 'dart:io';
import 'dart:math';

Future<String> solveDay09() async {
  final inputFile = File('lib/day09/input.txt');
  final lines = await inputFile.readAsLines();
  return 'part1: ${findTailMoves(lines, 2)}, part2: ${findTailMoves(lines, 10)}';
}

int findTailMoves(List<String> lines, int knotsLength) {
  List<Knot> knots = List.generate(knotsLength, (index) {
    if (index == 0) {
      return Knot(name: 'H');
    } else {
      return Knot(name: index.toString());
    }
  });

  Set<String> visitedPositions = {};

  void tryToMoveTail() {
    for (int i = 1; i <= knotsLength - 1; i++) {
      final knot = knots[i];
      final nextKnot = knots[i - 1];
      int xDistance = nextKnot.x - knot.x;
      int yDistance = nextKnot.y - knot.y;
      if (max(xDistance.abs(), yDistance.abs()) > 1) {
        // more than one spac
        if (xDistance.abs() >= 1) {
          if (xDistance < 0) {
            knot.x -= 1;
          } else {
            knot.x += 1;
          }
        }
        if (yDistance.abs() >= 1) {
          if (yDistance < 0) {
            knot.y -= 1;
          } else {
            knot.y += 1;
          }
        }
      }
    }
  }

  void printState() {
    for (int y = -6; y <= 6; y ++) {
      for (int x = -6; x <= 6; x++) {
        try {
          final knot = knots.firstWhere((element) => element.x == x && element.y == y);
          stdout.write(' ${knot.name} ');
        } catch (e) {
          stdout.write(' . ');
        }
      }
      print('\n');
    }
    print('\n\n\n');
  }

  for (final line in lines) {
    final variables = line.split(' ');
    final direction = Direction.parse(variables[0]);
    final moveCount = int.parse(variables[1]);

    for (int i = 1; i <= moveCount; i++) {
      switch (direction) {
        case Direction.left:
          knots.first.x -= 1;
          tryToMoveTail();
          break;
        case Direction.up:
          knots.first.y -= 1;
          tryToMoveTail();
          break;
        case Direction.right:
          knots.first.x += 1;
          tryToMoveTail();
          break;
        case Direction.down:
          knots.first.y += 1;
          tryToMoveTail();
          break;
      }
      visitedPositions.add('${knots.last.x},${knots.last.y}');
      // printState();
    }
  }
  return visitedPositions.length;
}

enum Direction {
  left,
  up,
  right,
  down;

  static Direction parse(String dir) {
    switch (dir) {
      case 'L':
        return left;
      case 'U':
        return up;
      case 'R':
        return right;
      case 'D':
        return down;
      default:
        throw StateError('invalid');
    }
  }
}

class Knot {
  String name;
  int x;
  int y;

  Knot({
    required this.name,
    this.x = 0,
    this.y = 0,
  });
}
