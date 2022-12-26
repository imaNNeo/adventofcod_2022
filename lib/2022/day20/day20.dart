import 'dart:io';

import 'package:equatable/equatable.dart';

Future<String> solveDay20() async {
  final inputFile = File('lib/2022/day20/input.txt');
  final input = await inputFile.readAsString();
  final originalNumbers = input.split('\n').asMap().entries.map((e) {
    return IndexNumber(e.key, int.parse(e.value));
  }).toList();
  return ''
      'part1: ${part1(originalNumbers)}, '
      'part2: ${part2(originalNumbers)}';
}

int part1(List<IndexNumber> originalNumbers) {
  final mixedList = mixNumbers(originalNumbers);
  return calculateGrooveSum(mixedList);
}

int part2(List<IndexNumber> originalNumbers) {
  int decryptionKey = 811589153;
  int divisor = (decryptionKey % (originalNumbers.length - 1));
  originalNumbers = originalNumbers
      .map((number) => IndexNumber(number.index, number.value * divisor))
      .toList();
  List<IndexNumber> mixedList = List.of(originalNumbers);
  for (int i = 1; i <= 10; i++) {
    mixedList = mixNumbers(originalNumbers, providedMixedList: mixedList);
  }
  int sum = 0;
  int indexOfZero = mixedList.map((e) => e.value).toList().indexOf(0);
  for (int num in [1000, 2000, 3000]) {
    final normalValue = mixedList[(indexOfZero + num) % mixedList.length].value;
    final adding = (normalValue ~/ divisor) * decryptionKey;
    sum += adding;
  }
  return sum;
}

int calculateGrooveSum(List<IndexNumber> mixedList) {
  int sum = 0;
  int indexOfZero = mixedList.map((e) => e.value).toList().indexOf(0);
  for (int num in [1000, 2000, 3000]) {
    sum += mixedList[(indexOfZero + num) % mixedList.length].value;
  }
  return sum;
}

List<IndexNumber> mixNumbers(
  List<IndexNumber> originalNumbers, {
  List<IndexNumber>? providedMixedList,
}) {
  var mixedList = providedMixedList ?? List.of(originalNumbers);
  for (final number in originalNumbers) {
    final index = mixedList.indexOf(number);
    mixedList.removeAt(index);
    int newPosition = (index + number.value) % mixedList.length;
    if (newPosition == 0) {
      mixedList.add(number);
    } else {
      mixedList.insert(newPosition, number);
    }
  }
  return mixedList;
}

class IndexNumber with EquatableMixin {
  final int index;
  final int value;

  IndexNumber(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}
