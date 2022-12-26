import 'dart:io';

import 'package:adventofcode/utils/collection.dart';
import 'package:adventofcode/utils/pair.dart';
import 'package:adventofcode/utils/position.dart';

Future<String> solveDay23() async {
  final inputFile = File('lib/2022/day23/input.txt');
  final input = await inputFile.readAsString();

  return 'part1: ${part1(input)}, part2: ${part2(input)}';
}

int part1(String input) {
  Map<Position, String> map = _parseInput(input);
  int turn = 1;
  while (true) {
    if (turn == 10) {
      return _countSpaces(map);
    }
    final proposed = proposeMove(map, turn);
    _moveToProposedPositions(map, proposed);
    turn++;
  }
}

int part2(String input) {
  Map<Position, String> map = _parseInput(input);
  int turn = 1;
  while (true) {
    final proposed = proposeMove(map, turn - 1);
    if (proposed.isEmpty) {
      return turn;
    }
    _moveToProposedPositions(map, proposed);
    turn++;
  }
}

Map<Position, String> _parseInput(String input) {
  Map<Position, String> map = {};
  final lines = input.split('\n');
  for (int y = 0; y < lines.length; y++) {
    final line = lines[y];
    for (int x = 0; x < line.length; x++) {
      final char = line[x];
      if (char == '#') {
        map[Position(x, y)] = line[x];
      }
    }
  }
  return map;
}

int _countSpaces(Map<Position, String> map) {
  final minX = map.keys.map((e) => e.x).min();
  final maxX = map.keys.map((e) => e.x).max();
  final minY = map.keys.map((e) => e.y).min();
  final maxY = map.keys.map((e) => e.y).max();
  int count = 0;
  for (int y = minY; y <= maxY; y++) {
    for (int x = minX; x <= maxX; x++) {
      final pos = Position(x, y);
      if (!map.containsKey(pos)) {
        count++;
      }
    }
  }
  return count;
}

List<Pair<Position, Position>> proposeMove(
    Map<Position, String> map, int turn) {
  final proposedMove = <Pair<Position, Position>>[];

  List<Position> topAdjacent(Position pos) =>
      [pos.topLeft, pos.top, pos.topRight];
  List<Position> bottomAdjacent(Position pos) =>
      [pos.bottomLeft, pos.bottom, pos.bottomRight];
  List<Position> leftAdjacent(Position pos) =>
      [pos.topLeft, pos.left, pos.bottomLeft];
  List<Position> rightAdjacent(Position pos) =>
      [pos.topRight, pos.right, pos.bottomRight];

  List checkingAdjacent = [
    topAdjacent,
    bottomAdjacent,
    leftAdjacent,
    rightAdjacent
  ];

  for (final entry in map.entries) {
    final pos = entry.key;
    if (!_hasAdjacent(map, pos)) {
      continue;
    }

    final adj1 = checkingAdjacent[(turn + 0) % 4](pos);
    if (!_hasAdjacent(map, pos, customAdjacent: adj1)) {
      proposedMove.add(Pair(pos, adj1[1]));
      continue;
    }

    final adj2 = checkingAdjacent[(turn + 1) % 4](pos);
    if (!_hasAdjacent(map, pos, customAdjacent: adj2)) {
      proposedMove.add(Pair(pos, adj2[1]));
      continue;
    }

    final adj3 = checkingAdjacent[(turn + 2) % 4](pos);
    if (!_hasAdjacent(map, pos, customAdjacent: adj3)) {
      proposedMove.add(Pair(pos, adj3[1]));
      continue;
    }

    final adj4 = checkingAdjacent[(turn + 3) % 4](pos);
    if (!_hasAdjacent(map, pos, customAdjacent: adj4)) {
      proposedMove.add(Pair(pos, adj4[1]));
      continue;
    }
  }
  return proposedMove;
}

void _moveToProposedPositions(
  Map<Position, String> map,
  List<Pair<Position, Position>> proposed,
) {
  Set<Position> duplicateDestinations = {};

  final allDestinations = proposed.map((e) => e.second);
  for (var dest in allDestinations) {
    final count = allDestinations.where((element) => element == dest).length;
    if (count > 1) {
      duplicateDestinations.add(dest);
    }
  }
  proposed.removeWhere((element) => duplicateDestinations.contains(element.second));
  for (final pair in proposed) {
    final prevPos = pair.first;
    final newPos = pair.second;
    final char = map.remove(prevPos)!;
    map[newPos] = char;
  }
}

bool _hasAdjacent(Map<Position, String> map, Position pos,
    {List<Position>? customAdjacent}) {
  bool hasAdjacent = false;
  for (final adj in customAdjacent ?? pos.adjacent) {
    if (map.containsKey(adj)) {
      hasAdjacent = true;
      break;
    }
  }
  return hasAdjacent;
}
