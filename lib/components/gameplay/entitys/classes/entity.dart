import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

///Create entity
///entityCollisionType: String rectangle/circle
///entitySize: Vector2 the size of the entity
///entityCollisionRadius: double the radius for circle collision
///entityCollisionMultiply: double the multiply for collision
class Entity extends PositionComponent with CollisionCallbacks {
  //Entity Parameters
  final String entityCollisionType;
  Vector2 entityPosition;
  Vector2 entitySize;
  double entityCollisionRadius;
  double entityCollisionMultiply;
  Entity({
    required this.entityPosition,
    required this.entitySize,
    this.entityCollisionType = "rectangle",
    this.entityCollisionRadius = 16.0,
    this.entityCollisionMultiply = 1,
    priority = 100,
  }) : super(
          position: entityPosition,
          size: entitySize,
          priority: priority,
        );

  @override
  void onMount() {
    super.onMount();
    switch (entityCollisionType) {
      case "rectangle":
        add(RectangleHitbox(size: entitySize * entityCollisionMultiply, anchor: Anchor.center, position: size / 2, isSolid: true));
        break;
      case "circle":
        add(CircleHitbox(radius: entityCollisionRadius * entityCollisionMultiply, anchor: Anchor.center, position: size / 2, isSolid: true));
        break;
    }
  }

  void changePosition(Vector2 position) {
    position = position;
  }
}
