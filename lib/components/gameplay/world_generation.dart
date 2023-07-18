import 'dart:async';

import 'package:flame/components.dart';

class WorldGeneration extends SpriteComponent {
  generateWorld(List<dynamic> worldData, gameController) {
    //All Tiles Columns
    for (int i = 0; i < worldData[0].length; i++) {
      //All Tiles Row
      for (int j = 0; j < worldData[0][i].length; j++) {
        gameController.add(WorldTile(
          worldTiles[worldData[0][i][j]].tileSprite,
          worldTiles[worldData[0][i][j]].tileSize,
          0,
          Vector2(double.parse(j.toString()), double.parse(i.toString())),
        ));
      }
    }
  }

  final worldTiles = [
    //Grass
    WorldTile(
      Sprite.load('tilesets/overworld/grass.png'),
      Vector2(32, 32),
      0,
      Vector2(0.0, 0.0),
    ),
    //Stone
    WorldTile(
      Sprite.load('tilesets/overworld/stone.png'),
      Vector2(32, 32),
      1,
      Vector2(0.0, 0.0),
    ),
    //Stone Down
    WorldTile(
      Sprite.load('tilesets/overworld/stone_down.png'),
      Vector2(32, 32),
      2,
      Vector2(0.0, 0.0),
    ),
  ];
}

class WorldTile extends SpriteComponent with HasCollisionDetection {
  int tileCollision = 0;
  Vector2 tileSize = Vector2(32, 32);
  Future<Sprite> tileSprite = Sprite.load('tilesets/overworld/grass.png');
  Vector2 tilePosition = Vector2(0.0, 0.0);

  WorldTile(
    this.tileSprite,
    this.tileSize,
    this.tileCollision,
    this.tilePosition,
  ) : super(size: tileSize, position: tilePosition);

  @override
  Future<void> onLoad() async {
    sprite = await tileSprite;
  }
}
