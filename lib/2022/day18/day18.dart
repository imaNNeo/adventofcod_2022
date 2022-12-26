import 'dart:io';

import 'package:adventofcode/utils/collection.dart';
import 'package:equatable/equatable.dart';

Future<String> solveDay18() async {
  final inputFile = File('lib/2022/day18/input.txt');
  final input = await inputFile.readAsString();

  final List<Cube> cubes = [];
  for (final line in input.split('\n')) {
    int x = int.parse(line.split(',')[0]);
    int y = int.parse(line.split(',')[1]);
    int z = int.parse(line.split(',')[2]);
    cubes.add(Cube(x, y, z));
  }

  return 'part1: ${_part1(cubes)}, part2: ${_part2(cubes)}';
}

int _part1(List<Cube> cubes) {
  int sides = 0;
  for (final cube in cubes) {
    sides += 6;
    for (final adjacent in cube.adjacentCubes) {
      if (cubes.contains(adjacent)) {
        sides -= 1;
      }
    }
  }
  return sides;
}

int _part2(List<Cube> cubes) {
  final sorted = cubes.toList();
  sorted.sort((a, b) => (a.x + a.y + a.z).compareTo(b.x + b.y + b.z));
  final minimum = sorted.first;

  late Cube firstAir;
  for (final d in minimum.adjacentCubes) {
    if (!cubes.contains(d)) {
      firstAir = d;
    }
  }

  List<Cube> queue = [firstAir];
  Set<Cube> airBlocks = {};
  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    airBlocks.add(current);
    for (final adjacent in current.adjacentCubes) {
      if (airBlocks.contains(adjacent) ||
          cubes.contains(adjacent) ||
          queue.contains(adjacent)) {
        continue;
      }
      if (_shortestDistance(cubes, adjacent) > 2) {
        continue;
      }
      queue.add(adjacent);
    }
  }

  int surfaceArea = 0;
  for (final airBlock in airBlocks) {
    for (final adjacent in airBlock.adjacentCubes) {
      if (cubes.contains(adjacent)) {
        surfaceArea++;
      }
    }
  }

  return surfaceArea;
}

int _shortestDistance(List<Cube> cubes, Cube target) => cubes.map((cube) {
      return (target.x - cube.x).abs() +
          (target.y - cube.y).abs() +
          (target.z - cube.z).abs();
    }).min();

class Cube with EquatableMixin {
  final int x, y, z;

  List<Cube> get adjacentCubes => [
        Cube(x + 1, y, z),
        Cube(x - 1, y, z),
        Cube(x, y + 1, z),
        Cube(x, y - 1, z),
        Cube(x, y, z + 1),
        Cube(x, y, z - 1),
      ];

  Cube(this.x, this.y, this.z);

  @override
  List<Object?> get props => [x, y, z];
}
