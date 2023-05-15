import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Recolector extends SpriteComponent {
  Recolector(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
  }

  static Future<Sprite> loadSprite() async {
    final completer = Completer<Sprite>();
    final data = await rootBundle.load('assets/images/canasta.png');
    decodeImageFromList(data.buffer.asUint8List(), (image) {
      final sprite = Sprite.load('canasta.png');
      completer.complete(sprite);
    });
    return completer.future;
  }

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite();
  }
}
