import 'dart:io';

import 'dart:math';

final charToValue = {
  '=': -2,
  '-': -1,
  '0': 0,
  '1': 1,
  '2': 2,
};

final valueToChar = Map<int, String>.fromEntries(
  charToValue.entries.map((e) => MapEntry(e.value, e.key)),
);

final base = charToValue.entries.length;

Future<String> solveDay25() async {
  final inputFile = File('lib/2022/day25/input.txt');
  final input = await inputFile.readAsString();
  int sum = 0;
  for (final line in input.split('\n')) {
    sum += _decodeNumber(line);
  }
  return 'part1: ${_encodeNumber(sum)}';
}

int _decodeNumber(String line) {
  int sum = 0;
  for (int i = 0; i < line.length; i++) {
    final char = line[i];
    final charValue = charToValue[char]!;
    sum += pow(base, line.length - i - 1).toInt() * charValue;
  }
  return sum;
}

String _encodeNumber(int number) {
  if (number == 0) {
    return '0';
  }
  final result = [];
  while (number != 0) {
    final remaining = (number + 2) % 5;
    number = (number + 2) ~/ 5;
    result.add(valueToChar[remaining - 2]!);
  }
  return result.reversed.join();
}
