import 'dart:io';

import 'package:adventofcode/utils/collection.dart';
import 'package:adventofcode/utils/position.dart';

Future<String> solveDay15() async {
  final inputFile = File('lib/2022/day15/input.txt');
  final input = await inputFile.readAsString();

  List<Position> sensors = [];
  List<Position> beacons = [];
  Map<Position, String> map = {};

  for (final line in input.split('\n')) {
    int parseSection(String section) {
      return int.parse(
        section
            .replaceAll(',', '')
            .replaceAll('x=', '')
            .replaceAll('y=', '')
            .replaceAll(':', ''),
      );
    }

    final sensor = Position(
      parseSection(line.split(' ')[2]),
      parseSection(line.split(' ')[3]),
    );
    sensors.add(sensor);
    map[sensor] = 'S';

    final beacon = Position(
      parseSection(line.split(' ')[8]),
      parseSection(line.split(' ')[9]),
    );
    beacons.add(beacon);
    map[beacon] = 'B';
  }

  int minX = sensors.map((s) => s.x).min();
  int maxX = sensors.map((s) => s.x).max();
  int maxDistance = List.generate(
      sensors.length, (i) => sensors[i].manhattanDistanceTo(beacons[i])).max();

  Position? isCovered(Position pos) {
    for (int i = 0; i < sensors.length; i++) {
      final sensor = sensors[i];
      final distance = sensor.manhattanDistanceTo(beacons[i]);
      if (pos.manhattanDistanceTo(sensor) <= distance) {
        return sensor;
      }
    }
    return null;
  }

  int part1 = 0;
  for (int x = minX - maxDistance; x <= maxX + maxDistance; x++) {
    final pos = Position(x, 2000000);
    if (map.containsKey(pos)) {
      continue;
    }
    final coveredBySensor = isCovered(pos);
    if (coveredBySensor != null) {
      part1++;
    }
  }

  int part2 = -1;
  for (int i = 0; i < sensors.length; i++) {
    final sx = sensors[i].x;
    final sy = sensors[i].y;
    final d = sensors[i].manhattanDistanceTo(beacons[i]);

    for (int dx = 0; dx < d + 2; dx++) {
      final dy = (d + 1) - dx;
      for (final sign in [
        Position(-1, -1),
        Position(-1, 1),
        Position(1, -1),
        Position(1, 1)
      ]) {
        final x = sx + (dx * sign.x);
        final y = sy + (dy * sign.y);

        if (x < 0 || x > 4000000 || y < 0 || y > 4000000) {
          continue;
        }

        final coveredSensor = isCovered(Position(x, y));
        if (coveredSensor != null) {
          continue;
        }

        part2 = x * 4000000 + y;
        break;
      }
      if (part2 != -1) {
        break;
      }
    }
  }

  return 'part1: $part1, part2: $part2';
}
