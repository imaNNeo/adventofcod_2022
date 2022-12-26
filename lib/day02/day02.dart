import 'dart:io';

Future<String> solveDay02() async {
  final inputFile = File('lib/day02/input.txt');
  final lines = await inputFile.readAsLines();
  int sumScore = 0;
  for (final line in lines) {
    final values = line.split(' ');
    final otherShape = getOtherShape(values[0]);
    // final myShape = getMyShape(values[1]);
    final forcedResult = getForcedResult(values[1]);
    final myShape = getMyShapeToGetResult(otherShape, forcedResult);
    final result = getResult(otherShape, myShape);
    final addingScore =
        calculateResultScore(result) + calculateShapeScore(myShape);
    sumScore += addingScore;
  }
  return sumScore.toString();
}

Shape getMyShapeToGetResult(Shape otherShape, Result forcedResult) {
  switch (otherShape) {
    case Shape.rock:
      switch (forcedResult) {
        case Result.win:
          return Shape.paper;
        case Result.loose:
          return Shape.scissors;
        case Result.draw:
          return Shape.rock;
      }
    case Shape.paper:
      switch (forcedResult) {
        case Result.win:
          return Shape.scissors;
        case Result.loose:
          return Shape.rock;
        case Result.draw:
          return Shape.paper;
      }
    case Shape.scissors:
      switch (forcedResult) {
        case Result.win:
          return Shape.rock;
        case Result.loose:
          return Shape.paper;
        case Result.draw:
          return Shape.scissors;
      }
  }
  throw StateError('invalid');
}

// X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
Result getForcedResult(String character) {
  switch (character) {
    case 'X':
      return Result.loose;
    case 'Y':
      return Result.draw;
    case 'Z':
      return Result.win;
    default:
      throw StateError('invalid');
  }
}

// A for Rock, B for Paper, and C for Scissors
Shape getOtherShape(String character) {
  switch (character) {
    case 'A':
      return Shape.rock;
    case 'B':
      return Shape.paper;
    case 'C':
      return Shape.scissors;
    default:
      throw StateError('invalid');
  }
}

// X for Rock, Y for Paper, and Z for Scissors
Shape getMyShape(String character) {
  switch (character) {
    case 'X':
      return Shape.rock;
    case 'Y':
      return Shape.paper;
    case 'Z':
      return Shape.scissors;
    default:
      throw StateError('invalid');
  }
}

Result getResult(Shape otherShape, Shape myShape) {
  switch (otherShape) {
    case Shape.rock:
      switch (myShape) {
        case Shape.rock:
          return Result.draw;
        case Shape.paper:
          return Result.win;
        case Shape.scissors:
          return Result.loose;
      }
    case Shape.paper:
      switch (myShape) {
        case Shape.rock:
          return Result.loose;
        case Shape.paper:
          return Result.draw;
        case Shape.scissors:
          return Result.win;
      }
    case Shape.scissors:
      switch (myShape) {
        case Shape.rock:
          return Result.win;
        case Shape.paper:
          return Result.loose;
        case Shape.scissors:
          return Result.draw;
      }
  }
}

int calculateResultScore(Result result) {
  switch (result) {
    case Result.win:
      return 6;
    case Result.loose:
      return 0;
    case Result.draw:
      return 3;
    default:
      throw StateError('Invalid');
  }
}

int calculateShapeScore(Shape myShape) {
  switch (myShape) {
    case Shape.rock:
      return 1;
    case Shape.paper:
      return 2;
    case Shape.scissors:
      return 3;
    default:
      throw StateError('Invalid');
  }
}

enum Shape { rock, paper, scissors }

enum Result { win, loose, draw }
