import 'dart:math';
import 'container.dart';
import 'package:flame/text.dart';
import 'figurasusadas.dart';
import 'tap_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'drag_input.dart';

class MyGame extends FlameGame with KeyboardEvents {
  final sizeOfFigure = Vector2(100, 200);
  final sizeOfContainer = Vector2(200, 100);
  late TextComponent colisiones;
  late TextComponent speed;
  late TextComponent tiempo;
  late TextComponent puntaje;
  double score = 0;
  double figureSpeed = 1;
  double tiempoDeUltimaFigura = 0;
  double tiempoParaGenerarFigura = 2;
  bool aumentoDeVelocidad = false;

  @override
  bool get debugMode => true;
  int collisionCount = 0;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 133, 186, 211);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        moverIzquierda();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        moverDerecha();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void render(Canvas canvas) {
    final recolector = children.query<Recolector>().first;
    final size = Vector2(canvasSize.x, canvasSize.y);
    final DragInput drag = children.query<DragInput>().first;
    recolector.position =
        Vector2(recolector.position.x, size.y - sizeOfContainer.y);
    drag.position = Vector2(size.x / 2, size.y);
    drag.size = Vector2(size.x, sizeOfContainer.y * 2);

    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    final size = Vector2(
        canvasSize.x, canvasSize.y); // Asegurar la declaración de 'size'

    children.register<Recolector>();
    await add(speed = TextComponent(
        text: "velocidad: x$figureSpeed ", position: Vector2(0, 200)));
    await add(colisiones = TextComponent(
        text: "Figuras atrapadas: $collisionCount ",
        position: Vector2(0, 250)));
    await add(tiempo = TextComponent(
        text: 'Figura generada cada: $tiempoParaGenerarFigura' 's',
        position: Vector2(0, 300)));
    await add(puntaje =
        TextComponent(text: 'Score: $score' 'pts', position: Vector2(0, 350)));
    await super.onLoad();

    final sizeOfContainer = Vector2(300, 200);

    final recolector = Recolector(
      Vector2(size.x / 2, size.y - sizeOfContainer.y),
      sizeOfContainer,
    );
    await recolector.onLoad();

    await add(recolector);

    await add(TapButton(moverDerecha)
      ..position = Vector2(size.x - 50, 75)
      ..size = Vector2(100, 100));
    await add(TapButton(moverIzquierda)
      ..position = Vector2(50, 75)
      ..size = Vector2(100, 100));
    await add(
      DragInput((mover) {
        if (mover) {
          moverDerecha();
        } else {
          moverIzquierda();
        }
      })
        ..position = Vector2(size.x, size.y - sizeOfContainer.y)
        ..size = Vector2(size.x, sizeOfContainer.y),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Asegurar la declaración de 'size'

    tiempoDeUltimaFigura += dt;

    if (tiempoDeUltimaFigura >= tiempoParaGenerarFigura) {
      addRandomFigure();
      tiempoDeUltimaFigura = 0;
    }

    if (collisionCount != 0 &&
        collisionCount % 10 == 0 &&
        !aumentoDeVelocidad) {
      if (tiempoParaGenerarFigura >= 0.5) {
        tiempoParaGenerarFigura -= .1;
        String tiempogof = tiempoParaGenerarFigura.toStringAsFixed(1);
        tiempo.text = 'Figura generada cada: $tiempogof' 's';
      }

      figureSpeed += 1;
      aumentoDeVelocidad = true;
      speed.text = 'Velocidad: x$figureSpeed';
      // Aumenta la velocidad de las figuras
    }
    if (collisionCount % 10 != 0) {
      // Restablecer el estado del aumento de velocidad cuando el contador ya no sea un múltiplo de 10
      aumentoDeVelocidad = false;
    }

    for (Figure1 figura1 in children.query<Figure1>()) {
      figura1.position.y += figureSpeed; // Utiliza la velocidad actualizada
      if (figura1.position.y > size.y) {
        remove(figura1);
      }
      // Verificar colisión con Flower
      final recolector = children.query<Recolector>().first;
      if (figura1.isCollidingWith(recolector)) {
        score += 5 * figureSpeed;
        puntaje.text = 'Score: $score' 'pts';
        // Incrementar contador de colisiones

        collisionCount++;
        colisiones.text = 'Figuras atrapadas: $collisionCount';

        // Eliminar la figura (Pinguino)
        remove(figura1);
      }
    }
    for (Figure3 figura3 in children.query<Figure3>()) {
      figura3.position.y += figureSpeed; // Utiliza la velocidad actualizada
      if (figura3.position.y > size.y) {
        remove(figura3);
      }
      // Verificar colisión
      //con Flower
      final recolector = children.query<Recolector>().first;
      if (figura3.isCollidingWith(recolector)) {
        score += 5 * figureSpeed;
        puntaje.text = 'Score: $score' 'pts';

        // Incrementar contador de colisiones
        collisionCount++;
        colisiones.text = 'Figuras atrapadas: $collisionCount';

        // Eliminar la figura (Pinguino)
        remove(figura3);
      }
    }
    for (Figure2 figura2 in children.query<Figure2>()) {
      figura2.position.y += figureSpeed; // Utiliza la velocidad actualizada
      if (figura2.position.y > size.y) {
        remove(figura2);
      }
      // Verificar colisión con Flower
      final recolector = children.query<Recolector>().first;
      if (figura2.isCollidingWith(recolector)) {
        score += 5 * figureSpeed;
        puntaje.text = 'Score: $score' 'pts';
        // Incrementar contador de colisiones
        collisionCount++;
        colisiones.text = 'Figuras atrapadas: $collisionCount';

        // Eliminar la figura (Pinguino)
        remove(figura2);
      }
    }
  }

  void moverIzquierda() {
    final Recolector recolector = children.query<Recolector>().first;
    recolector.position.x -= 50;

    if (recolector.position.x + recolector.width < 0) {
      recolector.position.x = size.x;
    }
  }

  void moverDerecha() {
    final Recolector recolector = children.query<Recolector>().first;
    recolector.position.x += 50;

    if (recolector.position.x > size.x) {
      recolector.position.x = -recolector.size.x;
    }
  }

  void addRandomFigure() {
    final random = Random();
    double tafig = Random().nextDouble();

    final position = Vector2(
      random.nextDouble() * (size.x - sizeOfFigure.x),
      0,
    );
    final color = HSLColor.fromAHSL(
      1,
      random.nextDouble() * 360,
      random.nextDouble() * 1,
      random.nextDouble() * 0.8,
    ).toColor();

    final sizefigV =
        Vector2(tafig * sizeOfFigure.x + 10, tafig * sizeOfFigure.y + 20);
    final sizefigH =
        Vector2(tafig * sizeOfFigure.y + 20, tafig * sizeOfFigure.x + 10);

    // Generar figura aleatoria
    final figureIndex = random.nextInt(3);

    switch (figureIndex) {
      case 0:
        add(Figure1(
            position: position, size: sizefigV, paint: Paint()..color = color));
        break;
      case 1:
        add(Figure2(
            position: position, size: sizefigV, paint: Paint()..color = color));
        break;
      case 2:
        add(Figure3(
            position: position, size: sizefigH, paint: Paint()..color = color));
        break;
    }
  }
}
