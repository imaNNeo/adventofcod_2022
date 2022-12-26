
import 'dart:io';

Future<String> solveDay01() async {
  final inputFile = File('lib/2022/day01/input.txt');
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
  return 'part1: ${part1(carriedCalories)}, part2: ${part2(carriedCalories)}';
}

int part1(List<int> calories) {
  return calories.first;
}

int part2(List<int> calories) {
  return calories[0] + calories[1] + calories[2];
}