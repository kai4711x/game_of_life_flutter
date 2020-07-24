import 'dart:ui';

/// The "business rule" of the game. Depending on the count of neighbours,
/// the [alive] changes.
class CellState {
  CellState(this.alive);
  final bool alive;

  bool reactToNeighbours(int neighbours) {
    if (neighbours == 3) {
      return true;
    } else if (neighbours != 2) {
      return false;
    }
    return alive;
  }
}

/// A coordinate on the [Grid].
class Point {
  const Point(this.x, this.y);

  final int x;
  final int y;

  operator +(other) => Point(x + other.x, y + other.y);

  @override
  int get hashCode => hashValues(x, y);

  @override
  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  String toString() => '($x, $y)';
}

/// The grid is an endless, two-dimensional [field] of cell [State]s.
class Grid {
  Grid({this.xCount, this.yCount, List<Point> alivePoints = const []}) {
    alivePoints.forEach((point) => field[point] = true);
  }

  final int xCount;
  final int yCount;
  Map<Point, bool> field = {};

  int countLiveNeighbours(Point point) =>
      neighbourPoints.where((offset) => field[point + offset] == true).length;

  void iterate({Function(Point) onUpdate}) {
    for (var x = 0; x < xCount; x++) {
      for (var y = 0; y < yCount; y++) {
        onUpdate(Point(x, y));
      }
    }
  }

  /// List of the relative indices of the 8 cells around a cell.
  static List<Point> neighbourPoints = [
    Point(-1, -1),
    Point(0, -1),
    Point(1, -1),
    Point(-1, 0),
    Point(1, 0),
    Point(-1, 1),
    Point(0, 1),
    Point(1, 1),
  ];
}

/// The game updates the [grid] in each step using the [CellState].
class Game {
  Game(this.grid);
  final Grid grid;

  void tick() {
    final newField = <Point, bool>{};

    grid.iterate(onUpdate: (point) {
      final cellState = CellState(grid.field[point] ?? false);
      final liveNeighbours = grid.countLiveNeighbours(point);
      newField[point] = cellState.reactToNeighbours(liveNeighbours);
    });

    grid.field = newField;
  }
}

extension GridBeacon on Grid {
  static Grid beacon() {
    final alive = [
      Point(1, 1),
      Point(1, 2),
      Point(2, 1),
      Point(4, 3),
      Point(3, 4),
      Point(4, 4),
    ];
    return Grid(xCount: 6, yCount: 6, alivePoints: alive);
  }
}

extension GridPulsar on Grid {
  static Grid pulsar() {
    final alive = [
      // top left
      Point(4, 2),
      Point(5, 2),
      Point(6, 2),
      Point(2, 4),
      Point(2, 5),
      Point(2, 6),
      Point(4, 7),
      Point(5, 7),
      Point(6, 7),
      Point(7, 4),
      Point(7, 5),
      Point(7, 6),
      // top right
      Point(10, 2),
      Point(11, 2),
      Point(12, 2),
      Point(9, 4),
      Point(9, 5),
      Point(9, 6),
      Point(10, 7),
      Point(11, 7),
      Point(12, 7),
      Point(14, 4),
      Point(14, 5),
      Point(14, 6),
      // bottom left
      Point(4, 9),
      Point(5, 9),
      Point(6, 9),
      Point(2, 10),
      Point(2, 11),
      Point(2, 12),
      Point(4, 14),
      Point(5, 14),
      Point(6, 14),
      Point(7, 10),
      Point(7, 11),
      Point(7, 12),
      // bottom right
      Point(10, 9),
      Point(11, 9),
      Point(12, 9),
      Point(9, 10),
      Point(9, 11),
      Point(9, 12),
      Point(10, 14),
      Point(11, 14),
      Point(12, 14),
      Point(14, 10),
      Point(14, 11),
      Point(14, 12),
    ];
    return Grid(xCount: 17, yCount: 17, alivePoints: alive);
  }
}

//     final startPoints = [Point(0, 1), Point(1, 1), Point(2, 1)];
