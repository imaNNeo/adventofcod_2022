import 'dart:io';

import 'package:adventofcode/utils/collection.dart';
import 'package:adventofcode/utils/position.dart';
import 'package:adventofcode/utils/utils.dart';
import 'package:equatable/equatable.dart';

Future<String> solveDay22() async {
  final inputFile = File('lib/2022/day22/input.txt');
  final input = await inputFile.readAsString();
  return ''
      'part1: ${part1(input)}, '
      'part2: ${part2(input)}';
}


int part1(String input) {
  final entry = loadArea(input);
  final caves = entry.key;
  final movements = entry.value;

  Position position = Position(caves[0].indexOf(Area.empty), 0);
  var direction = Direction.right;

  for (final movement in movements) {
    if (movement == 'L') {
      direction = direction.turnLeft();
    } else if (movement == 'R') {
      direction = direction.turnRight();
    } else {
      for (int i = 1; i <= (movement as int); i ++) {
        Position newPosition = position.copyWith();
        switch(direction) {
          case Direction.left:
            final wantedX = position.x - 1;
            if (wantedX < 0 || caves[position.y][wantedX] == Area.nothing) {
              newPosition = position.copyWith(x: caves[position.y].lastIndexWhere((element) => element != Area.nothing));
            } else {
              newPosition = position.copyWith(x: wantedX);
            }
            break;
          case Direction.right:
            final wantedX = position.x + 1;
            if (wantedX >= caves[position.y].length || caves[position.y][wantedX] == Area.nothing) {
              newPosition = position.copyWith(x: caves[position.y].indexWhere((element) => element != Area.nothing));
            } else {
              newPosition = position.copyWith(x: wantedX);
            }
            break;
          case Direction.up:
            final wantedY = position.y - 1;
            if (wantedY < 0 || caves[wantedY][position.x] == Area.nothing) {
              for (int yY = caves.length - 1; yY >= 1; yY--) {
                if (caves[yY][position.x] != Area.nothing) {
                  newPosition = position.copyWith(y: yY);
                  break;
                }
              }
            } else {
              newPosition = position.copyWith(y: wantedY);
            }
            break;
          case Direction.down:
            final wantedY = position.y + 1;
            if (wantedY >= caves.length || caves[wantedY][position.x] == Area.nothing) {
              for (int yY = 0; yY < caves.length - 1; yY++) {
                if (caves[yY][position.x] != Area.nothing) {
                  newPosition = position.copyWith(y: yY);
                  break;
                }
              }
            } else {
              newPosition = position.copyWith(y: wantedY);
            }
            break;
        }
        if (caves[newPosition.y][newPosition.x] == Area.empty) {
          position = newPosition;
        }
      }
    }
  }

  return findPassword(position, direction);
}

int part2(String input) {
  final entry = loadArea(input);
  final caves = entry.key;
  final movements = entry.value;

  Position position = Position(caves[0].indexOf(Area.empty), 0);
  var direction = Direction.right;
  var cubeFace = CubeFace.faceOne;

  for (final movement in movements) {
    if (movement == 'L') {
      direction = direction.turnLeft();
    } else if (movement == 'R') {
      direction = direction.turnRight();
    } else {
      for (int i = 1; i <= (movement as int); i++) {
        late FaceTransition transition;
        switch(direction) {
          case Direction.left:
            transition = _moveLeft(caves, position, direction, cubeFace);
            break;
          case Direction.right:
            transition = _moveRight(caves, position, direction, cubeFace);
            break;
          case Direction.up:
            transition = _moveUp(caves, position, direction, cubeFace);
            break;
          case Direction.down:
            transition = _moveDown(caves, position, direction, cubeFace);
            break;
        }

        if (caves[transition.newPosition.y][transition.newPosition.x] == Area.empty) {
          position = transition.newPosition;
          direction = transition.newDirection;
          cubeFace = transition.newFace;
        }
      }
    }
  }

  return findPassword(position, direction);
}

FaceTransition _moveLeft(List<List<Area>> caves, Position position,
    Direction direction, CubeFace cubeFace) {
  var transition = FaceTransition(position.copyWith(x: position.x - 1), direction, cubeFace);
  if (transition.newPosition.x < 0 ||
      caves[transition.newPosition.y][transition.newPosition.x] == Area.nothing) {
    if (cubeFace == CubeFace.faceOne) {
      transition = CubeFace.leftToRight(position.y, cubeFace, CubeFace.faceFour);
    } else if (cubeFace == CubeFace.faceThree) {
      transition = CubeFace.leftToDown(position.y, cubeFace, CubeFace.faceFour);
    } else if (cubeFace == CubeFace.faceFour) {
      transition = CubeFace.leftToRight(position.y, cubeFace, CubeFace.faceOne);
    } else if (cubeFace == CubeFace.faceSix) {
      transition = CubeFace.leftToDown(position.y, cubeFace, CubeFace.faceOne);
    }
  } else {
    if (cubeFace == CubeFace.faceTwo) {
      if (transition.newPosition.x < cubeFace.minX) {
        transition.newFace = CubeFace.faceOne;
      }
    } else if (cubeFace == CubeFace.faceFive) {
      if (transition.newPosition.x < cubeFace.minX) {
        transition.newFace = CubeFace.faceFour;
      }
    }
  }
  return transition;
}

FaceTransition _moveRight(List<List<Area>> caves, Position position,
    Direction direction, CubeFace cubeFace) {
  var transition = FaceTransition(position.copyWith(x: position.x + 1), direction, cubeFace);
  if (transition.newPosition.x >= caves[transition.newPosition.y].length ||
      caves[transition.newPosition.y][transition.newPosition.x] == Area.nothing) {
    if (cubeFace == CubeFace.faceTwo) {
      transition = CubeFace.rightToLeft(position.y, cubeFace, CubeFace.faceFive);
    } else if (cubeFace == CubeFace.faceThree) {
      transition = CubeFace.rightToUp(position.y, cubeFace, CubeFace.faceTwo);
    } else if (cubeFace == CubeFace.faceFive) {
      transition = CubeFace.rightToLeft(position.y, cubeFace, CubeFace.faceTwo);
    } else if (cubeFace == CubeFace.faceSix) {
      transition = CubeFace.rightToUp(position.y, cubeFace, CubeFace.faceFive);
    }
  } else {
    if (cubeFace == CubeFace.faceOne) {
      if (transition.newPosition.x > cubeFace.maxX) {
        transition.newFace = CubeFace.faceTwo;
      }
    } else if (cubeFace == CubeFace.faceFour) {
      if (transition.newPosition.x > cubeFace.maxX) {
        transition.newFace = CubeFace.faceFive;
      }
    }
  }
  return transition;
}

FaceTransition _moveUp(List<List<Area>> caves, Position position,
    Direction direction, CubeFace cubeFace) {
  var transition = FaceTransition(position.copyWith(y: position.y - 1), direction, cubeFace);
  if (transition.newPosition.y < 0 ||
      caves[transition.newPosition.y][transition.newPosition.x] == Area.nothing) {
    if (cubeFace == CubeFace.faceOne) {
      transition = CubeFace.upToRight(position.x, cubeFace, CubeFace.faceSix);
    } else if (cubeFace == CubeFace.faceTwo) {
      transition = CubeFace.upToUp(position.x, cubeFace, CubeFace.faceSix);
    } else if (cubeFace == CubeFace.faceFour) {
      transition = CubeFace.upToRight(position.x, cubeFace, CubeFace.faceThree);
    }
  } else {
    if (cubeFace == CubeFace.faceThree) {
      if (transition.newPosition.y < cubeFace.minY) {
        transition.newFace = CubeFace.faceOne;
      }
    } else if (cubeFace == CubeFace.faceFive) {
      if (transition.newPosition.y < cubeFace.minY) {
        transition.newFace = CubeFace.faceThree;
      }
    } else if (cubeFace == CubeFace.faceSix) {
      if (transition.newPosition.y < cubeFace.minY) {
        transition.newFace = CubeFace.faceFour;
      }
    }
  }
  return transition;
}

FaceTransition _moveDown(List<List<Area>> caves, Position position,
    Direction direction, CubeFace cubeFace) {
  var transition = FaceTransition(position.copyWith(y: position.y + 1), direction, cubeFace);

  if (transition.newPosition.y >= caves.length || caves[transition.newPosition.y][transition.newPosition.x] == Area.nothing) {
    if (cubeFace == CubeFace.faceTwo) {
      transition = CubeFace.downToLeft(position.x, cubeFace, CubeFace.faceThree);
    } else if (cubeFace == CubeFace.faceFive) {
      transition = CubeFace.downToLeft(position.x, cubeFace, CubeFace.faceSix);
    } else if (cubeFace == CubeFace.faceSix) {
      transition = CubeFace.downToDown(position.x, cubeFace, CubeFace.faceTwo);
    }
  } else {
    if (cubeFace == CubeFace.faceOne) {
      if (transition.newPosition.y > cubeFace.maxY) {
        transition.newFace = CubeFace.faceThree;
      }
    } else if (cubeFace == CubeFace.faceThree) {
      if (transition.newPosition.y > cubeFace.maxY) {
        transition.newFace = CubeFace.faceFive;
      }
    } else if (cubeFace == CubeFace.faceFour) {
      if (transition.newPosition.y > cubeFace.maxY) {
        transition.newFace = CubeFace.faceSix;
      }
    }
  }
  return transition;
}

enum Area { wall, empty, nothing }

MapEntry<List<List<Area>>, List<dynamic>> loadArea(String input) {
  final lines = input.split('\n');
  final rawInstructions = lines.removeLast();
  lines.removeLast(); //empty line

  List<dynamic> movements = [];

  int lastCharacterPos = 0;
  for (int i = 0; i < rawInstructions.length; i++) {
    if (isDigit(rawInstructions[i])) {
      if (i == rawInstructions.length - 1) {
        movements.add(int.parse(rawInstructions.substring(lastCharacterPos)));
      }
      continue;
    }
    movements.add(int.parse(rawInstructions.substring(lastCharacterPos, i)));
    final direction = rawInstructions[i];
    switch (direction) {
      case 'L':
        movements.add('L');
        break;
      case 'R':
        movements.add('R');
        break;
      default:
        throw StateError('invalid');
    }
    lastCharacterPos = i + 1;
  }

  final List<List<Area>> area = [];

  int maxWidth = lines.map((e) => e.length).max();
  for (final line in lines) {
    final row = List.generate(maxWidth, (index) => Area.nothing);
    for (int i = 0; i < line.length; i++) {
      switch (line[i]) {
        case '.':
          row[i] = Area.empty;
          break;
        case '#':
          row[i] = Area.wall;
          break;
      }
    }
    area.add(row);
  }

  return MapEntry(area, movements);
}

int findPassword(Position position, Direction direction) =>
    1000 * (position.y + 1) + (4 * (position.x + 1)) + direction.score;

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

class CubeFace with EquatableMixin {
  final int minX, maxX, minY, maxY;

  static const faceOne = CubeFace(50, 99, 0, 49);
  static const faceTwo = CubeFace(100, 149, 0, 49);
  static const faceThree = CubeFace(50, 99, 50, 99);
  static const faceFour = CubeFace(0, 49, 100, 149);
  static const faceFive = CubeFace(50, 99, 100, 149);
  static const faceSix = CubeFace(0, 49, 150, 199);

  const CubeFace(
      this.minX,
      this.maxX,
      this.minY,
      this.maxY,
      );

  static FaceTransition leftToRight(
      int y, CubeFace source, CubeFace destination) {
    final newX = destination.minX;
    final newY = destination.maxY - (y - source.minY);
    final newDirection = Direction.right;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition leftToDown(
      int y, CubeFace source, CubeFace destination) {
    final newX = destination.minX + (y - source.minY);
    final newY = destination.minY;
    final newDirection = Direction.down;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition rightToLeft(
      int y, CubeFace source, CubeFace destination) {
    final newX = destination.maxX;
    final newY = destination.maxY - (y - source.minY);
    final newDirection = Direction.left;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition rightToUp(
      int y, CubeFace source, CubeFace destination) {
    final newX = destination.minX + (y - source.minY);
    final newY = destination.maxY;
    final newDirection = Direction.up;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition upToRight(
      int x, CubeFace source, CubeFace destination) {
    final newX = destination.minX;
    final newY = destination.minY + (x - source.minX);
    final newDirection = Direction.right;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition upToUp(int x, CubeFace source, CubeFace destination) {
    final newX = destination.minX + (x - source.minX);
    final newY = destination.maxY;
    final newDirection = Direction.up;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition downToLeft(
      int x, CubeFace source, CubeFace destination) {
    final newX = destination.maxX;
    final newY = destination.minY + (x - source.minX);
    final newDirection = Direction.left;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  static FaceTransition downToDown(
      int x, CubeFace source, CubeFace destination) {
    final newX = destination.minX + (x - source.minX);
    final newY = destination.minY;
    final newDirection = Direction.down;
    return FaceTransition(Position(newX, newY), newDirection, destination);
  }

  @override
  List<Object?> get props => [minX, maxX, minY, maxY];
}

class FaceTransition {
  final Position newPosition;
  final Direction newDirection;
  CubeFace newFace;

  FaceTransition(
      this.newPosition,
      this.newDirection,
      this.newFace,
      );
}

