import 'dart:io';

import 'package:adventofcode/utils/pathfinding.dart';

Map<String, String> statements = {};

Future<String> solveDay21() async {
  final inputFile = File('lib/2022/day21/input.txt');
  final input = await inputFile.readAsString();

  for (final line in input.split('\n')) {
    final name = line.split(':')[0].trim();
    final statement = line.split(':')[1].trim();
    statements[name] = statement;
  }

  return 'part1: ${part1()}, part2: ${part2()}';
}

int part1() {
  return _calculate('root').toInt();
}

int part2() {
  final leftName = statements['root']!.split('+')[0].trim();
  final leftValue = _calculate(leftName);

  final rightName = statements['root']!.split('+')[1].trim();
  final rightValue = _calculate(rightName);

  assert(leftValue != rightValue);
  if (_hasHumanInTree(leftName, statements)) {
    // Human is in the left tree, we need the left tree result to be rightValue
    return _findHumanValue(leftName, rightValue).toInt();
  } else {
    // Human is in the right tree, we need the right tree result to be leftValue
    return _findHumanValue(rightName, leftValue).toInt();
  }
}

double _findHumanValue(String root, double preferredResult) {
  while (true) {
    String statement = statements[root]!;
    int? intValue = _tryToParseInt(statement);
    if (intValue != null) {
      if (root == 'humn') {
        // Found!!!! Human value must be preferredValue
        return preferredResult;
      }
    }
    final sections = statement.split(' ');
    final left = sections[0].trim();
    final operator = sections[1].trim();
    final right = sections[2].trim();

    final leftValue = _calculate(left).toInt();
    final rightValue = _calculate(right).toInt();
    if (_hasHumanInTree(left, statements)) {
      root = left;
      switch (operator) {
        case '+':
          preferredResult -= rightValue;
          break;
        case '-':
          preferredResult += rightValue;
          break;
        case '*':
          preferredResult /= rightValue;
          break;
        case '/':
          preferredResult *= rightValue;
          break;
        default:
          throw StateError('Invalid operator $operator');
      }
    } else if (_hasHumanInTree(right, statements)) {
      root = right;
      switch (operator) {
        case '+':
          preferredResult -= leftValue;
          break;
        case '-':
          preferredResult = -preferredResult + leftValue;
          break;
        case '*':
          preferredResult /= leftValue;
          break;
        case '/':
          preferredResult *= leftValue;
          break;
        default:
          throw StateError('Invalid operator $operator');
      }
    } else {
      throw StateError('Could not find human');
    }
  }
}

double _calculate(String name) {
  String statement = statements[name]!;
  int? intValue = _tryToParseInt(statement);
  if (intValue != null) {
    return intValue.toDouble();
  }
  final sections = statement.split(' ');
  final left = sections[0];
  final operator = sections[1];
  final right = sections[2];
  switch (operator) {
    case '+':
      return _calculate(left) + _calculate(right);
    case '-':
      return _calculate(left) - _calculate(right);
    case '*':
      return _calculate(left) * _calculate(right);
    case '/':
      return _calculate(left) / _calculate(right);
    default:
      throw StateError('Invalid operator $operator');
  }
}

bool _hasHumanInTree(String startPoint, Map<String, String> map) {
  bool hasInTree = false;
  bfs(
    start: startPoint,
    visit: (node, path, depth) {
      if (node == 'humn') {
        hasInTree = true;
      }
    },
    childrenOf: (String name) {
      final op = map[name]!;
      if (_tryToParseInt(op) != null) {
        return <String>[];
      }
      return [
        op.split(' ')[0].trim(),
        op.split(' ')[2].trim(),
      ];
    },
  );
  return hasInTree;
}

int? _tryToParseInt(String op) {
  try {
    return int.parse(op.trim());
  } catch (e) {
    return null;
  }
}
