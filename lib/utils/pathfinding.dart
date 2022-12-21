import 'package:collection/collection.dart';

Iterable<L>? aStarPath<L>({
  required L start,
  required L goal,
  required double Function(L) estimatedDistance,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final cameFrom = <L, L>{};
  final gScore = <L, double>{start: 0};
  final fScore = <L, double>{start: estimatedDistance(start)};
  int compareByScore(L a, L b) =>
      (fScore[a] ?? double.infinity).compareTo(fScore[b] ?? double.infinity);
  final openHeap = PriorityQueue<L>(compareByScore)..add(start);
  final openSet = {start};

  while (openSet.isNotEmpty) {
    L current = openHeap.removeFirst();
    openSet.remove(current);
    if (current == goal) {
      final path = [current];
      while (cameFrom.keys.contains(current)) {
        current = cameFrom[current] as L;
        path.insert(0, current);
      }
      return path;
    }
    for (final neighbor in neighborsOf(current)) {
      final tentativeScore = (gScore[current] ?? double.infinity) + costTo(current, neighbor);
      if (tentativeScore < (gScore[neighbor] ?? double.infinity)) {
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeScore;
        fScore[neighbor] = tentativeScore + estimatedDistance(neighbor);
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
          openHeap.add(neighbor);
        }
      }
    }
  }
  return null;
}

double? aStarLowestCost<L>({
  required L start,
  required L goal,
  required double Function(L) estimatedDistance,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {

  final cameFrom = <L, L>{};
  final gScore = <L, double>{start: 0};
  final fScore = <L, double>{start: estimatedDistance(start)};
  int compareByScore(L a, L b) =>
      (fScore[a] ?? double.infinity).compareTo(fScore[b] ?? double.infinity);
  final openHeap = PriorityQueue<L>(compareByScore)..add(start);
  final openSet = {start};

  while (openSet.isNotEmpty) {
    var current = openHeap.removeFirst();
    openSet.remove(current);
    if (current == goal) {
      return gScore[current];
    }
    for (final neighbor in neighborsOf(current)) {
      final tentativeScore = (gScore[current] ?? double.infinity) + costTo(current, neighbor);
      if (tentativeScore < (gScore[neighbor] ?? double.infinity)) {
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeScore;
        fScore[neighbor] = tentativeScore + estimatedDistance(neighbor);
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
          openHeap.add(neighbor);
        }
      }
    }
  }
  return null;
}

Iterable<L>? dijkstraPath<L>({
  required L start,
  required L goal,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final dist = <L, double>{start: 0};
  final prev = <L, L>{};
  int compareByDist(L a, L b) =>
      (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity);
  final queue = PriorityQueue<L>(compareByDist)..add(start);

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();
    if (current == goal) {
      // Reconstruct the path in reverse.
      final path = [current];
      while (prev.keys.contains(current)) {
        current = prev[current] as L;
        path.insert(0, current);
      }
      return path;
    }
    for (final neighbor in neighborsOf(current)) {
      final score = dist[current]! + costTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return null;
}

double? dijkstraLowestCost<L>({
  required L start,
  required L goal,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final dist = <L, double>{start: 0};
  final prev = <L, L>{};
  int compareByDist(L a, L b) =>
      (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity);
  final queue = PriorityQueue<L>(compareByDist)..add(start);

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();
    if (current == goal) {
      return dist[goal];
    }
    for (final neighbor in neighborsOf(current)) {
      final score = dist[current]! + costTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return null;
}

void dfs<Node>({
  required Node start,
  required Function(Node, List<Node> path, int depth) visit,
  required Iterable<Node> Function(Node) childrenOf,
}) {
  Set<Node> visited = {};
  visit(start, [start], 0);
  _recursiveDfs<Node>(
    node: start,
    childrenOf: childrenOf,
    visit: visit,
    visited: visited,
    path: [],
  );
}

void _recursiveDfs<Node>({
  required Node node,
  required Iterable<Node> Function(Node) childrenOf,
  required Function(Node node, List<Node> path, int depth) visit,
  required Set<Node> visited,
  required List<Node> path,
}) {
  path.add(node);
  for (final child in childrenOf(node)) {
    if (visited.contains(child)) {
      continue;
    }
    visited.add(child);
    visit(child, path + [child], path.length);
    _recursiveDfs(
      node: child,
      childrenOf: childrenOf,
      visit: visit,
      visited: visited,
      path: List.of(path),
    );
  }
}

void bfs<Node>({
  required Node start,
  required Function(Node, List<Node> path, int depth) visit,
  required Iterable<Node> Function(Node) childrenOf,
}) {
  Set<Node> visited = {};
  List<_NodeWithPath<Node>> queue = [_NodeWithPath(start, [])];

  _recursiveBfs<Node>(
    node: start,
    childrenOf: childrenOf,
    visit: visit,
    visited: visited,
    queue: queue,
  );
}

class _NodeWithPath <Node> {
  final Node node;
  final List<Node> path;
  _NodeWithPath(this.node, this.path);
}

void _recursiveBfs<Node>({
  required Node node,
  required Iterable<Node> Function(Node) childrenOf,
  required Function(Node node, List<Node> path, int depth) visit,
  required Set<Node> visited,
  required List<_NodeWithPath<Node>> queue,
}) {
  List<_NodeWithPath<Node>> newQueue = [];
  while (queue.isNotEmpty) {
    final nodeWithPath = queue.removeAt(0);
    final out = nodeWithPath.node;
    final path = nodeWithPath.path;
    if (!visited.contains(out)) {
      visit(out, path + [out], path.length);
      visited.add(out);
    }
    newQueue.addAll(childrenOf(out).map((n) => _NodeWithPath(n, path + [out])));
  }

  if (newQueue.isEmpty) {
    return;
  }
  _recursiveBfs(
    node: newQueue.first.node,
    childrenOf: childrenOf,
    visit: visit,
    visited: visited,
    queue: newQueue,
  );
}
