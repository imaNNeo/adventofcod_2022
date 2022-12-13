import 'dart:io';
import 'dart:convert';

late List<List<int>> heightMap;
late int mapWidth;
late int mapHeight;

Future<String> solveDay13() async {
  final inputFile = File('lib/day13/input.txt');
  final input = await inputFile.readAsString();
  final List<Group> groups = input.split('\n\n').map((g) {
    final lines = g.split('\n');
    return Group(lines[0], lines[1]);
  }).toList();

  int sum = 0;
  for (int i = 0; i < groups.length; i++) {
    final group = groups[i];
    if (isInRightOrder(group)) {
      sum += i + 1;
    }
  }

  List<dynamic> allLines = groups
      .map((e) => List.of([e.line1, e.line2]))
      .expand((element) => element)
      .map((e) => jsonDecode(e))
      .toList();
  allLines.add(jsonDecode('[[2]]'));
  allLines.add(jsonDecode('[[6]]'));
  allLines.sort(compare);

  int firstDividerLoc = -1;
  int secondDividerLoc = -1;
  for (int i = 0; i < allLines.length; i++) {
    if (compare(allLines[i], jsonDecode('[[2]]')) == 0) {
      firstDividerLoc = i + 1;
    } else if (compare(allLines[i], jsonDecode('[[6]]')) == 0) {
      secondDividerLoc = i + 1;
    }

    if (firstDividerLoc != -1 && secondDividerLoc != -1) {
      break;
    }
  }
  return 'part1: $sum, part2: ${firstDividerLoc * secondDividerLoc}';
}

int compare(dynamic left, dynamic right) {
  if (left is int && right is int) {
    return left.compareTo(right);
  }
  if (left is List && right is List) {
    int i = 0;
    while (true) {
      if (i >= left.length || i >= right.length) {
        return left.length.compareTo(right.length);
      }
      final result = compare(left[i], right[i]);
      if (result != 0) {
        return result;
      }
      i++;
    }
  }
  if (left is List) {
    assert(right is int);
    return compare(left, List.of([right as int]));
  }

  if (right is List) {
    assert(left is int);
    return compare(List.of([left as int]), right);
  }

  throw StateError('Invalid state, left is $left, right is $right');
}

bool isInRightOrder(Group g) {
  final left = jsonDecode(g.line1) as List<dynamic>;
  final right = jsonDecode(g.line2) as List<dynamic>;
  final result = compare(left, right);
  return result == -1;
}

class Group {
  final String line1;
  final String line2;

  Group(this.line1, this.line2);
}
