import 'dart:io';

import 'package:adventofcode/utils/pair.dart';

Future<String> solveDay05() async {
  final inputFile = File('lib/2022/day05/input.txt');
  final lines = await inputFile.readAsLines();
  return 'part1: ${part1(lines)}, part2: ${part2(lines)}';
}

String part1(List<String> inputLines) {
  final parsedInput = _parseInput(inputLines);
  final stacks = parsedInput.first;
  final commands = parsedInput.second;

  for (final command in commands) {
    for (int i = 1; i <= command.moveCount; i++) {
      stacks[command.moveTo-1].add(stacks[command.moveFrom-1].removeLast());
    }
  }
  return _readTopRow(stacks);
}

String part2(List<String> inputLines) {
  final parsedInput = _parseInput(inputLines);
  final stacks = parsedInput.first;
  final commands = parsedInput.second;

  for (final command in commands) {
    List<String> tempStack = [];
    for (int i = 1; i <= command.moveCount; i++) {
      final value = stacks[command.moveFrom-1].removeLast();
      tempStack.add(value);
    }
    for (int i = 1; i <= command.moveCount; i++) {
      final value = tempStack.removeLast();
      stacks[command.moveTo-1].add(value);
    }
  }
  return _readTopRow(stacks);
}

String _readTopRow(List<List<String>> stacks) {
  String result = '';
  for (final stack in stacks) {
    result += stack.last.replaceAll('[', '').replaceAll(']', '').trim();
  }
  return result;
}
Pair<List<List<String>>, List<Command>> _parseInput(List<String> lines) {
  List<List<String>> allData = _createDS(lines);
  List<Command> commands = [];
  int lineCounter = -1;
  for (var line in lines) {
    lineCounter += 1;
    if (line.contains(']')) {
      line += ' ';
      int pos = 0;
      int columnCounter = -1;
      while (true) {
        columnCounter += 1;
        if (line[pos] == ' ') {
          // empty
          pos += 4;
          continue;
        }
        final ss = line.substring(pos, pos + 4);
        allData[lineCounter][columnCounter] = ss;
        pos += 4;
        if (pos >= line.length) {
          break;
        }
      }
    } else if (line.trim().isEmpty || _isNumeric(line[1])) {
      //skip
      continue;
    } else {
      // command
      int fromIndex = line.indexOf('from');
      int toIndex = line.indexOf('to');
      int moveCount = int.parse(line.substring(4, fromIndex));
      int moveFrom = int.parse(line.substring(fromIndex + 4, toIndex));
      int moveTo = int.parse(line.substring(toIndex + 2));
      commands.insert(commands.length, Command(moveCount, moveFrom, moveTo));
    }
  }

  List<List<String>> stacks = List.generate(allData[0].length, (index) => []);

  for (int i = allData.length - 1; i >= 0; i--) {
    for (int j = allData[i].length - 1; j >= 0 ; j--) {
      final value = allData[i][j];
      if (value.trim().isEmpty) {
        continue;
      }
      stacks[j].add(value);
    }
  }
  return Pair(stacks, commands);
}

bool _isNumeric(String s) {
  return double.tryParse(s) != null;
}

List<List<String>> _createDS(List<String> lines) {
  int lineCounter = -1;
  int maxColumnCount = 0;
  for (var line in lines) {
    lineCounter++;
    if (line.contains(']')) {
      line += ' ';
      int pos = 0;
      int columnCounter = 0;
      while (true) {
        columnCounter += 1;
        if (line[pos] == ' ') {
          // empty
          pos += 4;
          continue;
        }
        pos += 4;
        if (pos >= line.length) {
          break;
        }
      }
      if (columnCounter > maxColumnCount) {
        maxColumnCount = columnCounter;
      }
    } else if (line.trim().isEmpty || _isNumeric(line[1])) {
      //skip
      return List.generate(lineCounter, (index) => List.generate(maxColumnCount, (index) => ' '));
    }
  }

  return [[]];
}

class Command {
  final int moveCount;
  final int moveFrom;
  final int moveTo;
  Command(this.moveCount, this.moveFrom, this.moveTo);
}