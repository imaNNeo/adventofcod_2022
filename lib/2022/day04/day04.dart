import 'dart:io';
import 'dart:math';

import 'package:adventofcode/utils/pair.dart';

Future<String> solveDay04() async {
  final inputFile = File('lib/2022/day04/input.txt');
  final lines = await inputFile.readAsLines();

  return 'part1: ${part1(lines)}, part2: ${part2(lines)}';
}

bool _isFullyOverlapped(_Line first, _Line second) {
  return first.fullyContains(second) || second.fullyContains(first);
}

int _getOverlapCount(_Line first, _Line second) {
  if (first.from >= second.from && first.from <= second.to) {
    return max(min(first.to, second.to) - first.from, 1);
  } else if (second.from >= first.from && second.from <= first.to) {
    return max(min(first.to, second.to) - second.from, 1);
  }
  return 0;
}

int part1(List<String> inputLines) {
  int sum = 0;
  for (final input in inputLines) {
    final parsedInput = _parseLinesData(input);
    if (_isFullyOverlapped(parsedInput.first, parsedInput.second)) {
      sum++;
    }
  }
  return sum;
}

int part2(List<String> inputLines) {
  int counter = 0;
  for (final input in inputLines) {
    final parsedInput = _parseLinesData(input);
    if (_getOverlapCount(parsedInput.first, parsedInput.second) > 0) {
      counter++;
    }
  }
  return counter;
}

Pair<_Line, _Line> _parseLinesData(String data) {
  final firstFrom = int.parse(data.split(',')[0].split('-')[0]);
  final firstTo = int.parse(data.split(',')[0].split('-')[1]);
  final secondFrom = int.parse(data.split(',')[1].split('-')[0]);
  final secondTo = int.parse(data.split(',')[1].split('-')[1]);
  return Pair(_Line(firstFrom, firstTo), _Line(secondFrom, secondTo));
}

class _Line {
  final int from;
  final int to;

  bool fullyContains(_Line other) {
    return other.from >= from && other.to <= to;
  }

  int partialOverlapCount(_Line other) {
    if (other.from >= from && other.from <= to) {
      return max(min(to, other.to) - other.from, 1);
    }
    return 0;
  }

  int get length => to - from;
  _Line(this.from, this.to);
}
