import 'dart:io';

Future<String> solveDay10() async {
  final inputFile = File('lib/day10/input.txt');
  final lines = await inputFile.readAsLines();

  int x = 1;
  int cycles = 0;

  int sum = 0;

  List<List<String>> screen = List.generate(6, (row) => List.generate(40, (col) => ' . '));

  void addSum() {
    List<int> checkingCycles = [20, 60, 100, 140, 180, 220];
    if (checkingCycles.contains(cycles)) {
      sum += cycles * x;
    }
  }

  void drawPixel() {
    int row = cycles ~/ 40;
    int col = cycles % 40;
    if (col >= x - 1 && col <= x + 1) {
      screen[row][col] = ' # ';
    } else {
      screen[row][col] = ' . ';
    }
  }

  for (final line in lines) {
    if (line == 'noop') {
      drawPixel();
      addSum();
      cycles++;
      continue;
    }

    //adx
    final addingX = int.parse(line.split(' ')[1]);


    drawPixel();
    addSum();
    cycles++;

    drawPixel();
    addSum();
    cycles++;
    x += addingX;
  }

  // printScreen(screen);
  return 'part1: $sum, part2: ZCBAJFJZ';
}

void printScreen(List<List<String>> screen) {
  for (final row in screen) {
    for (final col in row) {
      stdout.write(col);
    }
    print('');
  }
}