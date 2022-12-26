import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:adventofcode/utils/pathfinding.dart';
import 'package:collection/collection.dart';


late List<List<int>> heightMap;
late int mapWidth;
late int mapHeight;

Future<String> solveDay12() async {
  final inputFile = File('lib/2022/day12/input.txt');
  final lines = await inputFile.readAsLines();
  mapHeight = lines.length;
  mapWidth = lines.first.length;
  late Position givenStartPosition, givenEndPosition;
  List<Position> startPositionOptions = [];
  heightMap = List.generate(mapHeight, (row) {
    return List.generate(mapWidth, (col) {
      if (lines[row].contains('S')) {
        int index = lines[row].indexOf('S');
        lines[row] = lines[row].replaceAll('S', 'a');
        givenStartPosition = Position(row, index);
      } else if (lines[row].contains('E')) {
        int index = lines[row].indexOf('E');
        lines[row] = lines[row].replaceAll('E', 'z');
        givenEndPosition = Position(row, index);
      }
      if (lines[row][col] == 'a') {
        startPositionOptions.add(Position(row, col));
      }
      return lines[row].codeUnitAt(col);
    });
  });
  final startNode = Node(givenStartPosition);
  final endNode = Node(givenEndPosition);

  final part1 = dijkstraLowestCost<Node>(
    start: startNode,
    goal: endNode,
    costTo: (_, __) => 1,
    neighborsOf: (node) => node.children,
  )!.toInt();

  final part2 = startPositionOptions.map((startPos) {
        return dijkstraLowestCost<Node>(
          start: Node(startPos),
          goal: endNode,
          costTo: (_, __) => 1,
          neighborsOf: (node) => node.children,
        ) ?? double.infinity;
      }).min.toInt();


  return 'part1: $part1, part2: $part2';
}

class Position with EquatableMixin {
  final int x, y;

  Position(this.x, this.y);

  int get height => heightMap[x][y];

  Position get left => Position(x - 1, y);

  Position get top => Position(x, y - 1);

  Position get right => Position(x + 1, y);

  Position get bottom => Position(x, y + 1);

  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }

  Position distanceTo(Position other) {
    return Position(other.x - x, other.y - y);
  }

  @override
  List<Object?> get props => [x, y];
}

class Node with EquatableMixin {
  Position position;

  List<Node> get children {
    List<Node> availableOptions = [];
    if (position.left.x >= 0) {
      if (position.left.height - position.height <= 1) {
        availableOptions.add(Node(position.left));
      }
    }
    if (position.top.y >= 0) {
      if (position.top.height - position.height <= 1) {
        availableOptions.add(Node(position.top));
      }
    }
    if (position.right.x < mapHeight) {
      if (position.right.height - position.height <= 1) {
        availableOptions.add(Node(position.right));
      }
    }
    if (position.bottom.y < mapWidth) {
      if (position.bottom.height - position.height <= 1) {
        availableOptions.add(Node(position.bottom));
      }
    }
    return availableOptions;
  }

  int get height => heightMap[position.x][position.y];

  Node(this.position);

  @override
  List<Object?> get props => [position];
}

enum Direction {
  left(2),
  up(3),
  right(0),
  down(1);
  final int score;
  const Direction(this.score);

  Direction turnRight() {
    switch(this) {
      case Direction.left:
        return Direction.up;
      case Direction.up:
        return Direction.right;
      case Direction.right:
        return Direction.down;
      case Direction.down:
        return Direction.left;
    }
  }

  Direction turnLeft() {
    switch(this) {
      case Direction.left:
        return Direction.down;
      case Direction.up:
        return Direction.left;
      case Direction.right:
        return Direction.up;
      case Direction.down:
        return Direction.right;
    }
  }
}