import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

Future<String> solveDay19() async {
  final inputFile = File('lib/2022/day19/input.txt');
  final input = await inputFile.readAsString();
  final blueprints = parseInput(input);
  return ''
      'part1: ${part1(blueprints)}, '
      'part2: ${part2(blueprints)}';
}

int part1(List<Blueprint> blueprints) {
  int sumQuality = 0;
  int maxMinutes = 24;
  for (final blueprint in blueprints) {
    final initialState =
        State(0, initialRobots(), emptyResources(), emptyResources());
    final maxGeodes = _bfsToFindMaxGeodesCount(initialState, maxMinutes, blueprint);
    sumQuality += maxGeodes * blueprint.id;
  }
  return sumQuality;
}

int part2(List<Blueprint> blueprints) {
  int sumQuality = 1;
  int maxMinutes = 32;
  for (final blueprint in blueprints.sublist(0, 3)) {
    final initialState =
        State(0, initialRobots(), emptyResources(), emptyResources());
    final maxGeodes = _bfsToFindMaxGeodesCount(initialState, maxMinutes, blueprint);
    sumQuality *= maxGeodes;
  }
  return sumQuality;
}

Map<MaterialType, int> initialRobots() => {
      MaterialType.ore: 1,
      MaterialType.clay: 0,
      MaterialType.obsidian: 0,
      MaterialType.geode: 0,
    };

Map<MaterialType, int> emptyResources() => {
      MaterialType.ore: 0,
      MaterialType.clay: 0,
      MaterialType.obsidian: 0,
      MaterialType.geode: 0,
    };

int _bfsToFindMaxGeodesCount(State initialState, int maxMinutes, Blueprint blueprint) {
  List<State> queue = [initialState];
  int maxGeodesCount = 0;
  int depth = 0;
  int cutQueueAt = 1000;
  while (queue.isNotEmpty) {
    final state = queue.removeAt(0);
    if (state.minutes > depth) {
      // Prune the search space
      queue.sort((a, b) => b.qualityHeuristic.compareTo(a.qualityHeuristic));
      if (queue.length > cutQueueAt) {
        queue = queue.sublist(0, cutQueueAt);
      }
      depth = state.minutes;
    }

    if (state.minutes == maxMinutes) {
      maxGeodesCount = max(state.totalMined[MaterialType.geode]!, maxGeodesCount);
      continue;
    }

    // Create state without new robot and add to queue
    final newInventory = Map<MaterialType, int>.from(state.inventory);
    for (final robot in state.robots.entries) {
      newInventory[robot.key] = newInventory[robot.key]! + robot.value;
    }
    final newTotalMined = Map<MaterialType, int>.from(state.totalMined);
    for (final robot in state.robots.entries) {
      newTotalMined[robot.key] = newTotalMined[robot.key]! + robot.value;
    }
    queue.add(State(state.minutes + 1, state.robots, newInventory, newTotalMined));

    // If we have enough materials, we can build new robots and add the state to the queue
    for (final entry in blueprint.robots.entries.toList().reversed) {
      final robotType = entry.key;
      final robot = entry.value;

      // Check if we have enough materials to build a robot
      if (blueprint.canBuyRobot(robotType, state.inventory)) {
        final costs = robot.buildCost;
        final newInventory = Map<MaterialType, int>.from(state.inventory);
        for (final cost in costs.entries) {
          newInventory[cost.key] = newInventory[cost.key]! - cost.value;
        }
        for (final robot in state.robots.entries) {
          newInventory[robot.key] = newInventory[robot.key]! + robot.value;
        }
        final newRobots = Map<MaterialType, int>.from(state.robots);
        newRobots[robotType] = newRobots[robotType]! + 1;

        queue.add(
          State(state.minutes + 1, newRobots, newInventory, newTotalMined),
        );
      }
    }
  }
  return maxGeodesCount;
}

class State {
  final int minutes;
  final Map<MaterialType, int> robots;
  // materials at the moment
  final Map<MaterialType, int> inventory;
  // materials at the moment
  final Map<MaterialType, int> totalMined;

  int get qualityHeuristic {
    // As the famous saying goes:
    // 1 geode in the hand is worth 1000 in the bush
    final totalMinedScore = totalMined[MaterialType.geode]! * 1000 +
        totalMined[MaterialType.obsidian]! * 100 +
        totalMined[MaterialType.clay]! * 10 +
        totalMined[MaterialType.ore]! +
        1;

    final robotScore = robots[MaterialType.geode]! * 1000 +
        robots[MaterialType.obsidian]! * 100 +
        robots[MaterialType.clay]! * 10 +
        robots[MaterialType.ore]! +
        1;

    return totalMinedScore * robotScore;
  }

  State(this.minutes, this.robots, this.inventory, this.totalMined);
}

List<Blueprint> parseInput(String input) {
  return input.split('\n').map((line) {
    final sections = line.split(' ');
    final bluePrintId = int.parse(sections[1].replaceAll(':', ''));
    final robotsSection = line.substring(line.indexOf(':') + 2).split('.');
    final robots = Map.fromEntries(
        robotsSection.where((element) => element.trim().isNotEmpty).map((line) {
      final robotType = MaterialType.parseFrom(line.trim().split(' ')[1]);
      final costsSection = line
          .substring(line.indexOf('costs ') + 'costs '.length)
          .replaceAll('.', '');
      final costs = Map.fromEntries(costsSection.split('and ').map((entry) {
        final type = MaterialType.parseFrom(entry.split(' ')[1]);
        final cost = int.parse(entry.split(' ')[0]);
        return MapEntry<MaterialType, int>(type, cost);
      }));
      return MapEntry(robotType, Robot(robotType, costs));
    }));
    return Blueprint(bluePrintId, robots);
  }).toList();
}

enum MaterialType {
  ore,
  clay,
  obsidian,
  geode;

  static MaterialType parseFrom(String str) {
    switch (str) {
      case 'ore':
        return MaterialType.ore;
      case 'clay':
        return MaterialType.clay;
      case 'obsidian':
        return MaterialType.obsidian;
      case 'geode':
        return MaterialType.geode;
      default:
        throw StateError('Invalid input $str');
    }
  }
}

class Blueprint with EquatableMixin {
  final int id;
  final Map<MaterialType, Robot> robots;

  Blueprint(this.id, this.robots);

  bool canBuyRobot(MaterialType type, Map<MaterialType, int> resources) {
    for (final cost in robots[type]!.buildCost.entries) {
      if (resources[cost.key]! < cost.value) {
        return false;
      }
    }
    return true;
  }

  @override
  List<Object?> get props => [id, robots];
}

class Robot with EquatableMixin {
  final MaterialType type;
  final Map<MaterialType, int> buildCost;

  Robot(this.type, this.buildCost);

  @override
  List<Object?> get props => [type, buildCost];
}
