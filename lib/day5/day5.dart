import 'dart:collection';
import 'dart:io';

Future<String> solveDay5() async {
  final inputFile = File('lib/day5/input.txt');
  final lines = await inputFile.readAsLines();

  List<List<String>> allData = createDS(lines);
  int counter = 0;
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
    } else if (line.trim().isEmpty || isNumeric(line[1])) {
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

  List<Stack<String>> stacks = List.generate(allData[0].length, (index) => Stack());

  for (int i = allData.length - 1; i >= 0; i--) {
    for (int j = allData[i].length - 1; j >= 0 ; j--) {
      final value = allData[i][j];
      if (value.trim().isEmpty) {
        continue;
      }
      stacks[j].push(value);
    }
  }

  for (final command in commands) {
    Stack<String> tempStack = Stack();
    for (int i = 1; i <= command.moveCount; i++) {
      final value = stacks[command.moveFrom-1].pop();
      tempStack.push(value);
    }

    for (int i = 1; i <= command.moveCount; i++) {
      final value = tempStack.pop();
      stacks[command.moveTo-1].push(value);
    }
  }

  String finalResult = '';
  for (final stack in stacks) {
    finalResult += stack.peak().replaceAll('[', '').replaceAll(']', '').trim();
  }
  return finalResult;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

List<List<String>> createDS(List<String> lines) {
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
        final ss = line.substring(pos, pos + 4);
        pos += 4;
        if (pos >= line.length) {
          break;
        }
      }
      if (columnCounter > maxColumnCount) {
        maxColumnCount = columnCounter;
      }
    } else if (line.trim().isEmpty || isNumeric(line[1])) {
      //skip
      return List.generate(lineCounter, (index) => List.generate(maxColumnCount, (index) => ' '));
    }
  }

  return [[]];
}

class Stack<T> {
  final _stack = Queue<T>();

  int get length => _stack.length;

  bool canPop() => _stack.isNotEmpty;

  void clearStack() {
    while (_stack.isNotEmpty) {
      _stack.removeLast();
    }
  }

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  T peak() => _stack.last;
}


class Command {
  final int moveCount;
  final int moveFrom;
  final int moveTo;
  Command(this.moveCount, this.moveFrom, this.moveTo);
}