import 'package:equatable/equatable.dart';

class Pair<First, Second> with EquatableMixin {
  final First first;
  final Second second;

  Pair(this.first, this.second);

  Pair copyWith({
    First? first,
    Second? second,
  }) =>
      Pair(first ?? this.first, second ?? this.second);

  @override
  List<Object?> get props => [first, second];
}
