import 'dart:io';

Future<String> solveDay07() async {
  final inputFile = File('lib/day07/input.txt');
  final lines = await inputFile.readAsLines();

  late MyDirectory currentDir;
  String lastCommand = '';
  for (final line in lines) {
    final isCommand = line.startsWith('\$');
    if (line == '\$ cd /') {
      currentDir = MyDirectory(name: '/');
      continue;
    } else if (line == '\$ ls') {
      lastCommand = line;
      continue;
    } else if (line == '\$ cd ..') {
      currentDir = currentDir.parent!;
      continue;
    } else if (line.startsWith('\$ cd')) {
      final dirName = line.split(' ').last;
      currentDir = currentDir.directories
          .firstWhere((element) => element.name == dirName);
      continue;
    }
    if (!isCommand && lastCommand == '\$ ls') {
      final first = line.split(' ')[0];
      final second = line.split(' ')[1];
      if (first == 'dir') {
        //dir
        currentDir.addDir(MyDirectory(name: second, parent: currentDir));
      } else {
        //file
        currentDir.addFile(MyFile(name: second, size: int.parse(first)));
      }
    }
  }

  while (true) {
    if (currentDir.parent == null) {
      break;
    }
    currentDir = currentDir.parent!;
  }

  int sum = 0;
  int needSpace = 30000000 - (70000000 - currentDir.size);
  int minDeleteSize = 0;

  _BFS(currentDir, (MyDirectory dir) {
    if (dir.size <= 100000) {
      sum += dir.size;
    }
    if (dir.size >= needSpace) {
      if (minDeleteSize == 0 || dir.size < minDeleteSize) {
        minDeleteSize = dir.size;
      }
    }
  });

  return 'part1: $sum, part2: $minDeleteSize';
}

void _BFS(MyDirectory start, Function(MyDirectory) callback) {
  final queue = [start];

  callback(start);
  while (queue.isNotEmpty) {
    MyDirectory node = queue.removeLast();

    for (MyDirectory dir in node.directories) {
      callback(dir);
      queue.add(dir);
    }
  }
}

class MyDirectory {
  String name;
  List<MyFile> files = [];
  List<MyDirectory> directories = [];
  MyDirectory? parent;

  MyDirectory({
    required this.name,
    this.parent,
  });

  void addFile(MyFile file) {
    files.add(file);
  }

  void addDir(MyDirectory dir) {
    directories.add(dir);
  }

  int get dirsSize => directories.isEmpty
      ? 0
      : directories
          .map((e) => e.size)
          .reduce((value, element) => value + element);

  int get filesSize => files.isEmpty
      ? 0
      : files.map((e) => e.size).reduce((value, element) => value + element);

  int get size => dirsSize + filesSize;
}

class MyFile {
  String name;
  int size;

  MyFile({
    required this.name,
    required this.size,
  });
}
