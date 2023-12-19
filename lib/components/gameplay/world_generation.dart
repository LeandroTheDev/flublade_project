import 'dart:async';
import 'dart:convert';
import 'dart:math';

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
    //Null
    {
      'tileSprite': 'tilesets/overworld/grass.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
      'collisionType': 'RectangleHitbox',
      'isSolid': false,
    },
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

  ///Receives the world data and the gameController to add the tiles in the world
  List generateWorld(List<dynamic> worldData, FlameGame gameController, Vector2 playerPosition) {
    List tilesRendered = [];
    final chunkSquareRoot = sqrt(worldData.length);
    //Swipe all chunks
    double startX = 0;
    double startY = 0;
    for (int chunkIndex = 0; chunkIndex < chunkSquareRoot * chunkSquareRoot; chunkIndex++) {
      tilesRendered.add([]);
      //Pickup the actual chunk by index
      final actualChunk = worldData[chunkIndex];
      //Check if chunk is not null, null when chunk doesnt exist
      if (actualChunk == null) continue;
      //Actual tiles for the specific chunk
      final List actualTiles = jsonDecode(actualChunk["tiles"]);
      //Swiping the Y from the chunk
      for (int y = 0; y < actualTiles.length; y++) {
        //Swiping the X from the chunk
        for (int x = 0; x < actualTiles[y].length; x++) {
          //Create the component
          final component = WorldTile(
            worldTiles[actualTiles[y][x]]["tileSprite"].toString(),
            Vector2(double.parse(worldTiles[actualTiles[y][x]]["tileWidth"].toString()), double.parse(worldTiles[actualTiles[y][x]]["tileHeight"].toString())),
            Vector2(startX, startY),
            worldTiles[actualTiles[y][x]]["collisionType"],
            worldTiles[actualTiles[y][x]]["isSolid"],
          );
          //Adding to the world
          gameController.add(component);
          //Adding to the tiles rendered
          tilesRendered[chunkIndex].add(component);
          startX += 32;
        }
        startY += 32;
        startX = 0;
      }
    }
    return worldTiles;
  }

  ///Removes all Components in the list from the render
  void removeAllComponents(List components, FlameGame gameController) {
    for (int i = 0; i < components.length; i++) {
      gameController.remove(components[i]);
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
