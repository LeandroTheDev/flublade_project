import 'package:bonfire/bonfire.dart';

class ClassSpriteSheet {
  static final Map characterClass = {
    //Berserk
    'berserkidle': SpriteAnimation.load(
      "players/berserk/berserk_ingame_idleright.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    'bersekrun': SpriteAnimation.load(
        "players/berserk/berserk_ingame_runright.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      ),
  };
}
