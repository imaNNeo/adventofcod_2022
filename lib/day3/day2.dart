import 'dart:io';

Future<String> solveDay3() async {
  final inputFile = File('lib/day3/input.txt');
  final lines = await inputFile.readAsLines();

  int sumCode = 0;

  for (int i = 0; i < lines.length; i += 3) {
    final line1 = lines[i];
    final line2 = lines[i + 1];
    final line3 = lines[i + 2];

    String? ss;
    for (var c in line1.runes) {
      var char = String.fromCharCode(c);
      if (line2.contains(char) && line3.contains(char)) {
        ss = char;
        break;
      }
    }

    if (ss != null) {
      final value = ss.codeUnitAt(0);
      int charValue = 0;
      if (value >= 97 && value <= 122) {
        charValue = value - 96;
      } else if (value >= 65 && value <= 90) {
        charValue = value - 38;
      }

      sumCode += charValue;
    }
  }

  return '$sumCode';
}
