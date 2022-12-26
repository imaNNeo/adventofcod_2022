import 'dart:io';

Future<String> solveDay03() async {
  final inputFile = File('lib/2022/day03/input.txt');
  final lines = await inputFile.readAsLines();


  return 'part1: ${part1(lines)}, part2: ${part2(lines)}';
}

int part1(List<String> lines) {
  int sum = 0;
  for (final line in lines) {
    final left = line.substring(0, line.length ~/ 2);
    final right = line.substring(line.length ~/ 2);

    late String foundChar;
    for (int i = 0; i < left.length; i++) {
      if (right.contains(left[i])) {
        foundChar = left[i];
        break;
      }
    }
    sum += _getCharPriority(foundChar);
  }
  return sum;
}

int part2(List<String> lines) {
  int sumCode = 0;
  for (int i = 0; i < lines.length; i += 3) {
    final line1 = lines[i];
    final line2 = lines[i + 1];
    final line3 = lines[i + 2];

    late String foundChar;
    for (int i = 0; i < line1.length; i++) {
      var char = line1[i];
      if (line2.contains(char) && line3.contains(char)) {
        foundChar = char;
        break;
      }
    }
    sumCode += _getCharPriority(foundChar);
  }
  return sumCode;
}

int _getCharPriority(String char) {
  assert(char.length == 1);
  final value = char.codeUnitAt(0);
  int charValue = 0;
  if (value >= 97 && value <= 122) {
    charValue = value - 96;
  } else if (value >= 65 && value <= 90) {
    charValue = value - 38;
  }
  return charValue;
}