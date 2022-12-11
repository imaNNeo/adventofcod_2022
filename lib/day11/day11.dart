import 'dart:io';

Future<String> solveDay11() async {
  final inputFile = File('lib/day11/input.txt');
  final lines = await inputFile.readAsLines();
  return 'part1: ${resolve(lines, 20, true)}, part2: ${resolve(lines, 10000, false)}';
}

int resolve(List<String> lines, int rounds, bool devidedByThree) {
  List<Monkey> monkeys = [];
  List<int> divisibleByList = [];
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('Monkey ')) {
      monkeys.add(Monkey());
    } else if (line.startsWith('  Starting items: ')) {
      monkeys.last.items = line
          .replaceAll('  Starting items: ', '')
          .split(',')
          .map((e) => int.parse(e))
          .toList();
    } else if (line.startsWith('  Operation: new = ')) {
      final values = line.replaceAll('  Operation: new = ', '').split(' ');
      final firstParameter = values[0]; // always old
      final operation = values[1]; // + or *
      final secondParameter = values[2]; // old or number

      late bool isPlus;
      if (operation.trim() == '*') {
        isPlus = false;
      } else if (operation.trim() == '+') {
        isPlus = true;
      }

      bool isSecondVariableNumber;
      int? secondVarNumber;
      if (secondParameter.trim() == 'old') {
        isSecondVariableNumber = false;
      } else {
        isSecondVariableNumber = true;
        secondVarNumber = int.parse(secondParameter);
      }

      monkeys.last.operation = (input) {
        if (isPlus) {
          return input + (isSecondVariableNumber ? secondVarNumber! : input);
        } else {
          return input * (isSecondVariableNumber ? secondVarNumber! : input);
        }
      };
    } else if (line.startsWith('  Test: divisible by ')) {
      final divisibleBy = int.parse(line.replaceAll('Test: divisible by ', '').trim());
      divisibleByList.add(divisibleBy);
      final trueMonkeyNumber = int.parse(lines[++i].split(' ').last);
      final falseMonkeyNumber = int.parse(lines[++i].split(' ').last);
      monkeys.last.testDivisible = (thisMonkey, input) {
        if (input % divisibleBy == 0) {
          monkeys[trueMonkeyNumber].items.add(input);
        } else {
          monkeys[falseMonkeyNumber].items.add(input);
        }
      };
    }
  }


  final mod = divisibleByList.reduce((a, b) => a * b);
  for (int round = 1; round <= rounds; round ++) {
    for (int i = 0; i < monkeys.length; i++) {
      final monkey = monkeys[i];
      List<int> markForDelete = [];
      for (final item in monkey.items) {
        monkey.inspectItemCount++;
        markForDelete.add(item);
        int newItem = monkey.operation(item);
        newItem = devidedByThree ? newItem ~/ 3 : newItem % mod;
        monkey.testDivisible(monkey, newItem);
      }
      for (final d in markForDelete) {
        monkey.items.remove(d);
      }
    }
  }
  monkeys.sort((a, b) => b.inspectItemCount.compareTo(a.inspectItemCount));
  return monkeys[0].inspectItemCount * monkeys[1].inspectItemCount;
}

class Monkey {
  List<int> items = [];
  late int Function(int) operation;
  late Function(Monkey, int) testDivisible;
  int inspectItemCount = 0;
  Monkey();
}