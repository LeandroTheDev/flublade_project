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

  ///Return number to multiply the start position of chunk render
  ///need the double of square root to me stringify
  int calculateChunkNegative(String chunkSquareRoot) {
    //Will be better if i make a calculation to plus 2 add +1 but i will make this in future
    switch (chunkSquareRoot) {
      case "3.0":
        return 1;
      case "5.0":
        return 2;
      case "7.0":
        return 3;
      case "9.0":
        return 4;
      case "11.0":
        return 5;
      case "13.0":
        return 6;
      case "15.0":
        return 7;
      case "17.0":
        return 8;
      case "19.0":
        return 9;
      case "21.0":
        return 10;
    }
    return 0;
  }

  ///Receives the world data and the gameController to add the tiles in the world
  List generateWorld(List<dynamic> worldData, World gameController, Vector2 playerPosition) {
    List tilesRendered = [];
    final chunkSquareRoot = sqrt(worldData.length);
    // print("Chunk Square Root: $chunkSquareRoot, chunk quantity: ${worldData.length}"); //DEBUG
    int chunkPosition = 1;
    //Chunk Render Calculation Variables // Less 2 to exclude internal radius
    final chunkNegativeCalculation = (480 * calculateChunkNegative(chunkSquareRoot.toString()));
    double startX = playerPosition[0] - chunkNegativeCalculation;
    double startY = playerPosition[1] - chunkNegativeCalculation;
    double actualStartX = startX;
    double actualStartY = startY;
    // print("Starting Render Position: $startX, $startY"); //DEBUG
    //Swipe all chunks
    for (int chunkIndex = 0; chunkIndex < chunkSquareRoot * chunkSquareRoot; chunkIndex++) {
      // print("Rendering the chunk: $chunkIndex"); //DEBUG
      //Checking the actual positiion of chunk to see if we need to down the position
      if (chunkPosition > chunkSquareRoot) {
        //Reseting the position
        chunkPosition = 1;
        //Reseting the base X because we finished the X chunks now we are going lower
        startX = playerPosition[0] - chunkNegativeCalculation;
        actualStartX = startX;
        //Incresing the base Y because the X is finished and we need to go lower in the coordinates
        actualStartY += 480;
        startY = actualStartY;
      }
      // print("Chunk render startX: $startX, startY: $startY"); //DEBUG
      //Increase the chunk position
      chunkPosition++;
      tilesRendered.add([]);
      //Pickup the actual chunk by index
      final actualChunk = worldData[chunkIndex];
      //Check if chunk is not null, null when chunk doesnt exist
      if (actualChunk == null) {
        //Change chunk X position to the next chunk
        startX += 480;
        actualStartX = startX;
        continue;
      }
      //Actual tiles for the specific chunk
      final List actualTiles = jsonDecode(actualChunk["tiles"]);
      //Swiping the Y from the chunk
      for (int y = 0; y < actualTiles.length; y++) {
        // print("X: ${startX}, Y: ${startY}");
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
        //Reseting the X to render the lower tiles
        startX = actualStartX;
        //Incresing the Y to render lower tiles
        startY += 32;
      }
      actualStartX += 480;
      startY = actualStartY;
    }
    return tilesRendered;
  }

  ///Removes all Components in the list from the render
  void removeAllComponents(List components, World gameController) {
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
