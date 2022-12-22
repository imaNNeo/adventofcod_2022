import 'package:equatable/equatable.dart';

class Position with EquatableMixin {
  static const leftDir = Position(-1, 0);
  static const topDir = Position(0, -1);
  static const rightDir = Position(1, 0);
  static const bottomDir = Position(0, 1);

  final int x;
  final int y;

  Position get left => this + leftDir;
  Position get top => this + topDir;
  Position get right => this + rightDir;
  Position get bottom => this + bottomDir;

  const Position(this.x, this.y);

  Position copyWith({int? x, int? y}) => Position(x ?? this.x, y ?? this.y);

  Position rotateLeft() => Position(y, -x);
  Position rotateRight() => Position(-y, x);

  int manhattanDistanceTo(Position other) {
    final distanceX = (other.x - x).abs();
    final distanceY = (other.y - y).abs();
    return distanceX + distanceY;
  }

  @override
  List<Object?> get props => [x, y];

  Position operator -() => Position(-x, -y);
  Position operator -(Position other) => Position(x - other.x, y - other.y);
  Position operator +(Position other) => Position(x + other.x, y + other.y);
  Position operator *(int operand) => Position(x * operand, y * operand);
}