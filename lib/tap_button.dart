import 'dart:async' as async;
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

class TapButton extends PositionComponent with TapCallbacks {
  final void Function() onTap;

  TapButton(this.onTap) : super(anchor: Anchor.center);

  final _paint = Paint()..color = const Color.fromARGB(172, 170, 0, 0);
  bool isLongTapDown = false;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    isLongTapDown = true;

    async.Timer.periodic(const Duration(microseconds: 16), (timer) {
      if (isLongTapDown) {
        onTap();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onTapUp(TapUpEvent event) {
    isLongTapDown = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isLongTapDown = false;
  }
}
