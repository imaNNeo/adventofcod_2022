import 'dart:io';

Future<String> solveDay02() async {
  final inputFile = File('lib/2022/day02/input.txt');
  final lines = await inputFile.readAsLines();
  return 'part1: ${part1(lines)}, part2: ${part2(lines)}';
}

int part1(List<String> lines) {
  int sumScore = 0;
  for (final line in lines) {
    final values = line.split(' ');
    final otherShape = _getOtherShape(values[0]);
    final myShape = getMyShape(values[1]);
    final result = _getResult(otherShape, myShape);
    final addingScore =
        _calculateResultScore(result) + _calculateShapeScore(myShape);
    sumScore += addingScore;
  }
  return sumScore;
}

int part2(List<String> lines) {
  int sumScore = 0;
  for (final line in lines) {
    final values = line.split(' ');
    final otherShape = _getOtherShape(values[0]);
    // final myShape = getMyShape(values[1]);
    final forcedResult = _getForcedResult(values[1]);
    final myShape = _getMyShapeToGetResult(otherShape, forcedResult);
    final result = _getResult(otherShape, myShape);
    final addingScore =
        _calculateResultScore(result) + _calculateShapeScore(myShape);
    sumScore += addingScore;
  }
  return sumScore;
}

_Shape _getMyShapeToGetResult(_Shape otherShape, _Result forcedResult) {
  switch (otherShape) {
    case _Shape.rock:
      switch (forcedResult) {
        case _Result.win:
          return _Shape.paper;
        case _Result.loose:
          return _Shape.scissors;
        case _Result.draw:
          return _Shape.rock;
      }
    case _Shape.paper:
      switch (forcedResult) {
        case _Result.win:
          return _Shape.scissors;
        case _Result.loose:
          return _Shape.rock;
        case _Result.draw:
          return _Shape.paper;
      }
    case _Shape.scissors:
      switch (forcedResult) {
        case _Result.win:
          return _Shape.rock;
        case _Result.loose:
          return _Shape.paper;
        case _Result.draw:
          return _Shape.scissors;
      }
  }
  throw StateError('invalid');
}

// X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
_Result _getForcedResult(String character) {
  switch (character) {
    case 'X':
      return _Result.loose;
    case 'Y':
      return _Result.draw;
    case 'Z':
      return _Result.win;
    default:
      throw StateError('invalid');
  }
}

// A for Rock, B for Paper, and C for Scissors
_Shape _getOtherShape(String character) {
  switch (character) {
    case 'A':
      return _Shape.rock;
    case 'B':
      return _Shape.paper;
    case 'C':
      return _Shape.scissors;
    default:
      throw StateError('invalid');
  }
}

// X for Rock, Y for Paper, and Z for Scissors
_Shape getMyShape(String character) {
  switch (character) {
    case 'X':
      return _Shape.rock;
    case 'Y':
      return _Shape.paper;
    case 'Z':
      return _Shape.scissors;
    default:
      throw StateError('invalid');
  }
}

_Result _getResult(_Shape otherShape, _Shape myShape) {
  switch (otherShape) {
    case _Shape.rock:
      switch (myShape) {
        case _Shape.rock:
          return _Result.draw;
        case _Shape.paper:
          return _Result.win;
        case _Shape.scissors:
          return _Result.loose;
      }
    case _Shape.paper:
      switch (myShape) {
        case _Shape.rock:
          return _Result.loose;
        case _Shape.paper:
          return _Result.draw;
        case _Shape.scissors:
          return _Result.win;
      }
    case _Shape.scissors:
      switch (myShape) {
        case _Shape.rock:
          return _Result.win;
        case _Shape.paper:
          return _Result.loose;
        case _Shape.scissors:
          return _Result.draw;
      }
  }
}

int _calculateResultScore(_Result result) {
  switch (result) {
    case _Result.win:
      return 6;
    case _Result.loose:
      return 0;
    case _Result.draw:
      return 3;
    default:
      throw StateError('Invalid');
  }
}

int _calculateShapeScore(_Shape myShape) {
  switch (myShape) {
    case _Shape.rock:
      return 1;
    case _Shape.paper:
      return 2;
    case _Shape.scissors:
      return 3;
    default:
      throw StateError('Invalid');
  }
}

enum _Shape { rock, paper, scissors }

enum _Result { win, loose, draw }
