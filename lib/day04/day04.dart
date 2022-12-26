import 'dart:io';

Future<String> solveDay04() async {
  final inputFile = File('lib/day04/input.txt');
  final lines = await inputFile.readAsLines();

  int counter = 0;
  for (final line in lines) {
    final firstFrom = int.parse(line.split(',')[0].split('-')[0]);
    final firstTo = int.parse(line.split(',')[0].split('-')[1]);

    final secondFrom = int.parse(line.split(',')[1].split('-')[0]);
    final secondTo = int.parse(line.split(',')[1].split('-')[1]);

    if ((firstFrom >= secondFrom && firstFrom <= secondTo) ||
        (firstTo >= secondFrom && firstTo <= secondTo)) {
      counter += 1;
    } else if ((secondFrom >= firstFrom && secondFrom <= firstTo) ||
        (secondTo >= firstFrom && secondTo <= firstTo)) {
      counter += 1;
    }
  }

  return '$counter';
}
