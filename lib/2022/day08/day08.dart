import 'dart:io';

Future<String> solveDay08() async {
  final inputFile = File('lib/2022/day08/input.txt');
  final lines = await inputFile.readAsLines();

  final height = lines.length;
  final width = lines.first.length;
  List<List<int>> map = List.generate(
    height,
    (i) => List.generate(width, (j) => -1),
  );

  List<List<int>> scores = List.generate(
    height,
        (i) => List.generate(width, (j) => 1),
  );

  for (int x = 0; x < lines.length; x++) {
    final line = lines[x];
    for (int y = 0; y < line.runes.length; y++) {
      final rune = line.runes.toList()[y];
      map[x][y] = int.parse(String.fromCharCode(rune));
    }
  }

  Set<String> visibles = {};

  // left
  for (int x = 0; x < height; x++) {
    int previousMax = -1;
    for (int y = 0; y < width; y++) {
      final current = map[x][y];

      if (y != 0) {
        int visibleTrees = 0;
        for (int tempY = y - 1; tempY >= 0; tempY --) {
          visibleTrees++;
          if (map[x][tempY] >= current) {
            break;
          }
        }
        scores[x][y] *= visibleTrees;
      }

      if (current > previousMax) {
        // count it
        visibles.add('$x-$y');
        previousMax = current;
      }
    }
  }

  // top
  for (int y = 0; y < width; y++) {
    int previousMax = -1;
    for (int x = 0; x < height; x++) {
      final current = map[x][y];

      if (x != 0) {
        int visibleTrees = 0;
        for (int tempX = x - 1; tempX >= 0; tempX --) {
          visibleTrees++;
          if (map[tempX][y] >= current) {
            break;
          }
        }
        scores[x][y] *= visibleTrees;
      }

      if (current > previousMax) {
        // count it
        visibles.add('$x-$y');
        previousMax = current;
      }
    }
  }

  // right
  for (int x = 0; x < height; x++) {
    int previousMax = -1;
    for (int y = width - 1; y >= 0; y--) {
      final current = map[x][y];

      if (y != width - 1) {
        int visibleTrees = 0;
        for (int tempY = y + 1; tempY < width; tempY ++) {
          visibleTrees++;
          if (map[x][tempY] >= current) {
            break;
          }
        }
        scores[x][y] *= visibleTrees;
      }

      if (current > previousMax) {
        // count it
        visibles.add('$x-$y');
        previousMax = current;
      }
    }
  }

  // bottom
  for (int y = 0; y < width; y++) {
    int previousMax = -1;
    for (int x = height - 1; x >= 0; x--) {
      final current = map[x][y];

      if (x != height - 1) {
        int visibleTrees = 0;
        for (int tempX = x + 1; tempX < height; tempX ++) {
          visibleTrees++;
          if (map[tempX][y] >= current) {
            break;
          }
        }
        scores[x][y] *= visibleTrees;
      }

      if (current > previousMax) {
        // count it
        visibles.add('$x-$y');
        previousMax = current;
      }
    }
  }


  int max = 0;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (scores[x][y] > max) {
        max = scores[x][y];
      }
    }
  }

  final count = visibles.length;

  return 'part1: $count, part2: $max';
}
