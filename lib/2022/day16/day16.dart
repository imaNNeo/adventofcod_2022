import 'dart:io';
import 'dart:math';

import 'package:adventofcode/utils/collection.dart';
import 'package:adventofcode/utils/pathfinding.dart';
import 'package:equatable/equatable.dart';

Future<String> solveDay16() async {
  final inputFile = File('lib/2022/day16/input.txt');
  final input = await inputFile.readAsString();

  final valves = _parseValves(input);
  final distances = _floidWarshall(valves);

  final nonZeroValves = Map.of(valves);
  nonZeroValves.removeWhere((id, valve) => valve.flowRate == 0);

  Iterable<List<String>> generateOpenOptions(String pos, List<String> openValues, int timeLeft) sync* {
    for (final next in nonZeroValves.keys) {
      if (!openValues.contains(next) && distances[pos]![next]! < timeLeft) {
        openValues.add(next);
        yield* generateOpenOptions(
          next, openValues, timeLeft - distances[pos]![next]! - 1,
        );
        openValues.removeLast();
      }
    }
    yield List.of(openValues);
  }

  int getOrderScore(List<String> openOrder, int timeLeft) {
    String now = 'AA';
    int answer = 0;
    for (final pos in openOrder) {
      timeLeft -= distances[now]![pos]! + 1;
      answer += valves[pos]!.flowRate * timeLeft;
      now = pos;
    }
    return answer;
  }

  int part1() => generateOpenOptions('AA', [], 30).map((o) => getOrderScore(o, 30)).max();

  int part2() {
    final List<List<String>> ways = generateOpenOptions('AA', [], 26).toList();
    Map<String, int> bestScores = {};
    for (final List<String> order in ways) {
      final copiedOrder = List.of(order);
      copiedOrder.sort();
      final int score = getOrderScore(order, 26);
      bestScores[copiedOrder.join(',')] = max<int>(bestScores.getOrElse(copiedOrder.join(','), 0), score);
    }
    final List<MapEntry<List<String>, int>> bestScoreEntries =
      bestScores.entries.map((e) => MapEntry(e.key.split(','), e.value)).toList();
    int answer = 0;
    for (int humanIdx = 0; humanIdx < bestScoreEntries.length; humanIdx++) {
      for (int elephantIdx = humanIdx + 1; elephantIdx < bestScoreEntries.length; elephantIdx++) {
        final List<String> humanOpens = bestScoreEntries[humanIdx].key;
        final int humanScore = bestScoreEntries[humanIdx].value;

        final List<String> elephantOpens = bestScoreEntries[elephantIdx].key;
        final int elephantScore = bestScoreEntries[elephantIdx].value;

        if (humanOpens.toSet().intersection(elephantOpens.toSet()).isEmpty) {
          answer = max(answer, humanScore + elephantScore);
        }
      }
    }
    return answer;
  }

  return 'part1: ${part1()}, part2: ${part2()}';
}

Map<String, Map<String, int>> _floidWarshall(Map<String, _Valve> valves) {
  Map<String, Map<String, int>> dist= {};
  for (final outerValve in valves.keys) {
    dist[outerValve] = {};
    for (final innerValve in valves.keys) {
      dist[outerValve]![innerValve] = 1000000000;
    }
  }

  for (final v in valves.keys) {
    dist[v]![v] = 0;
    for (final u in valves[v]!.children) {
      dist[v]![u] = 1;
    }
  }

  for (final k in valves.keys) {
    for (final i in valves.keys) {
      for (final j in valves.keys) {
        dist[i]![j] = min(dist[i]![j]!, dist[i]![k]! + dist[k]![j]!);
      }
    }
  }

  return dist;
}

class _Valve {
  final String name;
  final int flowRate;
  final List<String> children;

  _Valve(this.name, this.flowRate, this.children);
}

Map<String, _Valve> _parseValves(String input) {
  Map<String, _Valve> valves = {};
  for (final line in input.split('\n')) {
    final id = line.split(' ')[1].trim();
    final flowRate = int.parse(
        line.split(' ')[4].replaceAll('rate=', '').replaceAll(';', ''));

    var childSubString = '';
    if (line.contains('values')) {
      childSubString =
          line.substring(line.indexOf('valves') + 'values'.length + 1);
    } else {
      childSubString =
          line.substring(line.indexOf('valve') + 'value'.length + 1);
    }
    final neighborIds = childSubString.split(',').map((e) => e.trim()).toList();
    valves[id] = _Valve(id, flowRate, neighborIds);
  }
  return valves;
}