
import 'dart:io';

Future<String> solveDay1() async {
  final inputFile = File('lib/day1/input.txt');
  final lines = await inputFile.readAsLines();
  List<int> carriedCalories = [];

  int currentCalories = 0;
  int counter = 0;
  for (final line in lines) {
    if (line.trim().isEmpty) {
      carriedCalories.insert(counter, currentCalories);
      currentCalories = 0;
      counter++;
      continue;
    }
    currentCalories += int.parse(line);
  }
  if (currentCalories != 0) {
    carriedCalories.insert(counter, currentCalories);
  }

  carriedCalories.sort();
  carriedCalories = carriedCalories.reversed.toList();
  final topThree = carriedCalories[0] + carriedCalories[1] + carriedCalories[2];
  return '$topThree';
}