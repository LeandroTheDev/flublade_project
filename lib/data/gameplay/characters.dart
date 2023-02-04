import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/gameplay/characters_sprites.dart';

class PlayerClient extends SimplePlayer {
  PlayerClient(Vector2 position)
      : super(
          position: position,
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: ClassSpriteSheet.characterClass['berserkidle'],
            runRight: ClassSpriteSheet.characterClass['bersekrun'],
          ),
        );
}
