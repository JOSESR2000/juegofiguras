import 'dart:ui';
import 'package:figuras_flame/figures.dart';
import 'package:flame/components.dart';

class Figure1 extends Pinguino {
  final String name;
  Figure1(
      {required super.position,
      required super.size,
      required super.paint,
      super.forma,
      this.name = 'Pinguino'});

  bool isCollidingWith(PositionComponent other) {
    final Rect myRect = toRect();
    final Rect otherRect = other.toRect();
    return myRect.overlaps(otherRect);
  }
}

class Figure2 extends Iguana {
  final String name;
  Figure2(
      {required super.position,
      required super.size,
      required super.paint,
      this.name = 'Iguana'});

  bool isCollidingWith(PositionComponent other) {
    final Rect myRect = toRect();
    final Rect otherRect = other.toRect();
    return myRect.overlaps(otherRect);
  }
}

class Figure3 extends Ballena {
  final String name;
  Figure3(
      {required super.position,
      required super.size,
      required super.paint,
      super.forma,
      this.name = 'Ballena'});

  bool isCollidingWith(PositionComponent other) {
    final Rect myRect = toRect();
    final Rect otherRect = other.toRect();
    return myRect.overlaps(otherRect);
  }
}
