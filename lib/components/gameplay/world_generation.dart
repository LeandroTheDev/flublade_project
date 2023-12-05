import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

//
//  DOCS
//
// WorldGeneration
// ---------------
// tileSpaceWidth/Height -- is the space between tiles the default is 32
//
// worldTiles -- variable that stores the tiles information (size, sprite path)

// WorldTile
// ---------
// Desc: WorldTile is the component that will render on the screen the respective tile, have some paramaters that will
// define the properties of tile.

class WorldGeneration extends SpriteComponent {
  static const worldTiles = [
    //Grass
    {
      'tileSprite': 'tilesets/overworld/grass.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
      'collisionType': 'none',
      'isSolid': false,
    },
    //Stone
    {
      'tileSprite': 'tilesets/overworld/stone.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
      'collisionType': 'RectangleHitbox',
      'isSolid': true,
    },
    //Stone Down
    {
      'tileSprite': 'tilesets/overworld/stone_down.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
      'collisionType': 'RectangleHitbox',
      'isSolid': true,
    },
  ];

  generateWorld(List<dynamic> worldData, FlameGame gameController) {
    double tileSpaceHeight = 0.0;
    double tileSpaceWidth = 0.0;
    //All Tiles Columns
    for (int i = 0; i < worldData[0].length; i++) {
      //All Tiles Row
      for (int j = 0; j < worldData[0][i].length; j++) {
        gameController.add(WorldTile(
          worldTiles[worldData[0][i][j]]["tileSprite"].toString(),
          Vector2(double.parse(worldTiles[worldData[0][i][j]]["tileWidth"].toString()),
              double.parse(worldTiles[worldData[0][i][j]]["tileHeight"].toString())),
          Vector2(tileSpaceWidth, tileSpaceHeight),
          worldTiles[worldData[0][i][j]]["collisionType"],
          worldTiles[worldData[0][i][j]]["isSolid"],
        ));
        //Add Width Spacer
        tileSpaceWidth += 31.0;
      }
      //Add Height Spacer
      tileSpaceHeight += 31.0;
      //Reset Width Spacer
      tileSpaceWidth = 0.0;
    }
  }
}

class WorldTile extends SpriteComponent {
  //Declaration
  final String tileSprite;
  final Vector2 tileSize;
  final Vector2 tilePosition;

  late String tileCollision;
  late bool tileIsSolid;

  WorldTile(
    //Request
    this.tileSprite,
    this.tileSize,
    this.tilePosition, [
    collision = 'RectangleHitbox',
    isSolid = true,
  ]
      //Setting
      ) : super(
          size: tileSize,
          position: tilePosition,
        ) {
    tileCollision = collision;
    tileIsSolid = isSolid;
  }

  @override
  Future<void> onLoad() async {
    //Load Sprite
    sprite = await Sprite.load(tileSprite);

    //Hitbox
    switch (tileCollision) {
      case "none":
        break;
      case "RectangleHitbox":
        add(RectangleHitbox(size: Vector2(32.0, 32.0), anchor: Anchor.center, position: size / 2, collisionType: CollisionType.passive));
        break;
    }
  }
}
