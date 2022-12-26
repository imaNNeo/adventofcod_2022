import 'dart:collection';
import 'dart:io';

Future<String> solveDay06() async {
  final inputFile = File('lib/2022/day06/input.txt');
  final line = (await inputFile.readAsLines())[0];
  final part1 = _findFirstUniqueBatch(line, 4);
  final part2 = _findFirstUniqueBatch(line, 14);
  return 'part1: $part1, part2: $part2';
}

int _findFirstUniqueBatch(String input, int uniqueCount) {
  for (int i = 0; i < input.length - uniqueCount; i++) {
    var setValues = <String>{};
    bool thereIsDuplicate = false;
    int j = 0;
    for (j = 0; j < uniqueCount; j++) {
      final value = input[i + j];
      if (setValues.contains(value)) {
        thereIsDuplicate = true;
        break;
      } else {
        setValues.add(value);
      }
    }
    if (thereIsDuplicate) {
      continue;
    } else {
      return i + uniqueCount;
    }
  }
  return -1;
}