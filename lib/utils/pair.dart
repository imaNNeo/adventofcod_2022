import 'package:equatable/equatable.dart';

class Pair<A, B> with EquatableMixin {
  final A a;
  final B b;

  Pair(this.a, this.b);

  Pair copyWith({
    A? a,
    B? b,
  }) =>
      Pair(a ?? this.a, b ?? this.b);

  @override
  List<Object?> get props => [a, b];
}
