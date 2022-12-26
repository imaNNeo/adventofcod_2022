import 'dart:io';
import 'dart:math';

import 'package:adventofcode/utils/collection.dart';

late List<List<int>> heightMap;
late int mapWidth;
late int mapHeight;

Future<String> solveDay14() async {
  final inputFile = File('lib/2022/day14/input.txt');
  final input = await inputFile.readAsString();

  return
      'part1: ${getSettledCount(createMapArea(input))}, '
      'part2: ${getSettledCount(createMapArea(input), hasFloor: true)}';
}

MapArea createMapArea(String input) {
  List<List<Line>> allRockLines = [];
  for (final line in input.split('\n')) {
    final points = line.split(' -> ');
    List<Line> rockLines = [];
    for (int i = 0; i < points.length - 1; i++) {
      final start = Position(
        int.parse(points[i].split(',')[0]),
        int.parse(points[i].split(',')[1]),
      );
      final end = Position(
        int.parse(points[i + 1].split(',')[0]),
        int.parse(points[i + 1].split(',')[1]),
      );
      rockLines.add(Line(start, end));
    }
    allRockLines.add(rockLines);
  }

  final allLines = allRockLines.expand((lines) => lines);
  final allPositions =
      allLines.expand((element) => [element.start, element.end]);
  final maxX = allPositions.map((e) => e.x).max();
  final minX = allPositions.map((e) => e.x).min();
  final maxY = allPositions.map((e) => e.y).max();
  final minY = 0;

  final mapArea = MapArea(minX, maxX, minY, maxY);
  for (var line in allLines) {
    if (line.start.x == line.end.x) {
      int from = min(line.start.y, line.end.y);
      int to = max(line.start.y, line.end.y);
      for (int y = from; y <= to; y++) {
        mapArea.putValue(line.start.x - minX, y, ' # ');
      }
    } else if (line.start.y == line.end.y) {
      int from = min(line.start.x, line.end.x);
      int to = max(line.start.x, line.end.x);
      for (int x = from; x <= to; x++) {
        mapArea.putValue(x - minX, line.start.y, ' # ');
      }
    } else {
      throw StateError('invalid');
    }
  }
  return mapArea;
}

int getSettledCount(
  MapArea mapArea, {
  bool hasFloor = false,
}) {
  int settledCount = 0;
  while (true) {
    var newSand = mapArea.sandStartFallPos.copyWith();
    bool finishLoop = false;
    while (true) {
      if (!hasFloor) {
        if (newSand.bottom.y >= mapArea.height ||
            newSand.bottom.x < 0 ||
            newSand.bottom.x >= mapArea.width) {
          finishLoop = true;
          break;
        }
        if (newSand.bottomLeft.y >= mapArea.height ||
            newSand.bottomLeft.x < 0 ||
            newSand.bottomLeft.x >= mapArea.width) {
          finishLoop = true;
          break;
        }
        if (newSand.bottomRight.y >= mapArea.height ||
            newSand.bottomRight.x < 0 ||
            newSand.bottomRight.x >= mapArea.width) {
          finishLoop = true;
          break;
        }
      }

      if (mapArea.isPositionAvailable(newSand.bottom, hasFloor: hasFloor)) {
        // bottom is empty and it can go bottom
        newSand = newSand.bottom;
      } else if (mapArea.isPositionAvailable(newSand.bottomLeft, hasFloor: hasFloor)) {
        // bottom left is empty and it can go bottom
        newSand = newSand.bottomLeft;
      } else if (mapArea.isPositionAvailable(newSand.bottomRight, hasFloor: hasFloor)) {
        // bottom right is empty and it can go bottom
        newSand = newSand.bottomRight;
      } else {
        mapArea.putValue(newSand.x, newSand.y, ' O ');
        settledCount++;
        if (newSand.x == mapArea.sandStartFallPos.x &&
            newSand.y == mapArea.sandStartFallPos.y) {
          finishLoop = true;
          break;
        }
        break;
      }
    }

    if (finishLoop) {
      break;
    }
  }
  return settledCount;
}

class MapArea {
  late Map<String, String> _map;

  final int minX, maxX, minY, maxY;

  late Position sandStartFallPos;

  int get width => (maxX - minX) + 1;

  int get height => (maxY - minY) + 1;

  MapArea(this.minX, this.maxX, this.minY, this.maxY) {
    _map = {};
    sandStartFallPos = Position(500 - minX, 0);
    putValue(sandStartFallPos.x, sandStartFallPos.y, ' + ');
  }

  void putValue(int x, int y, String value) {
    _map['$x,$y'] = value;
  }

  String? getValueByPos(Position pos) {
    return getValue(pos.x, pos.y);
  }

  String? getValue(int x, int y) {
    if (_map.containsKey('$x,$y')) {
      return _map['$x,$y'];
    } else {
      return ' . ';
    }
  }

  bool isPositionBlocked(Position pos) {
    String? value = getValue(pos.x, pos.y);
    return value == ' O ' || value == ' # ';
  }
  bool isPositionAvailable(Position pos, {bool hasFloor = false}) {
    if (isPositionBlocked(pos)) {
      return false;
    }

    if (hasFloor) {
      return pos.y <= maxY + 1;
    }

    return true;
  }
}

class Position {
  final int x;
  final int y;

  Position get bottom => Position(x, y + 1);

  Position get bottomLeft => Position(x - 1, y + 1);

  Position get bottomRight => Position(x + 1, y + 1);

  Position(this.x, this.y);

  Position copyWith({
    int? x,
    int? y,
  }) =>
      Position(x ?? this.x, y ?? this.y);
}

class Line {
  final Position start;
  final Position end;

  Line(this.start, this.end);
}
