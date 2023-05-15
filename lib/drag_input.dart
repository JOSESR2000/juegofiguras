import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

class DragInput extends PositionComponent with DragCallbacks {
  final void Function(bool mover) onDrag;

  DragInput(this.onDrag) : super(anchor: Anchor.center);

  final _rectPaint = Paint()..color = const Color(0x88AC54BF);
  Vector2 _dragStartPosition = Vector2.zero();

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _rectPaint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStartPosition = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final currentPosition = event.localPosition;
    final dx = currentPosition.x - _dragStartPosition.x;
    onDrag(dx > 0);
    _dragStartPosition = currentPosition;
  }
}
