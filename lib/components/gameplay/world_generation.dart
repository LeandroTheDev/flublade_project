import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flublade_project/components/navigator_engine.dart';

class WorldGeneration extends SpriteComponent {
  final NavigatorEngine engine;
  WorldGeneration(this.engine);

  static const worldTiles = [
    //Null
    {
      'tileSprite': 'tilesets/overworld/grass.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
    },
    //Grass
    {
      'tileSprite': 'tilesets/overworld/grass.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
    },
    //Stone
    {
      'tileSprite': 'tilesets/overworld/stone.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
    },
    //Stone Down
    {
      'tileSprite': 'tilesets/overworld/stone_down.png',
      'tileHeight': 32.0,
      'tileWidth': 32.0,
    },
  ];

  List<SpriteComponent> worldComponents = [];

  ///Check if asked a update for the server for not spamming
  bool alreadyAskedForUpdate = false;
  bool firstLoad = false;

  ///Return number to multiply the start position of chunk render
  ///need the double of square root to me stringify
  int calculateChunkNegative(String chunkSquareRoot) {
    //Will be better if i make a calculation to plus 2 add +1? yes obviously
    int chunkNegative = 1;
    int calculation = 3;
    while (true) {
      //The chunkSquareRoot is a string of a double so we need to make this awful thing
      if ("$calculation.0" == chunkSquareRoot) {
        return chunkNegative;
      } else {
        calculation += 2;
        chunkNegative += 1;
      }
    }
  }

  ///Receives a coordinates and return the closest multiple of 480
  double calculateStartCoordinate(int coordinate) {
    //Calculate the quotient of 480
    int quotient = (coordinate / 480).round();

    //Multiply the quotient by the 480 to obtain the proximity number
    int closestMultiple = quotient * 480;

    //If coordinate is bugged, ask for correction
    if (coordinate == closestMultiple && !alreadyAskedForUpdate) {
      alreadyAskedForUpdate = true;

      //First load need to ignore the chunk update is unecessary
      if (!firstLoad) {
        firstLoad = true;
      }
      //We ask for chunk updates
      else {
        engine.askForChunkUpdate();
        Future.delayed(const Duration(milliseconds: 100), () => alreadyAskedForUpdate = false);
      }
    }

    //We need to check if the player is in new chunk
    if (coordinate < closestMultiple) {
      //Increase a chunk
      closestMultiple -= 480;
    }

    return closestMultiple.toDouble();
  }

  ///Receives the world data and the gameController to add the tiles in the world
  void generateWorld(List<dynamic> worldData, World gameController, Vector2 playerPosition) {
    List<SpriteComponent> tilesRendered = [];
    final chunkSquareRoot = sqrt(worldData.length);
    // print("Chunk Square Root: $chunkSquareRoot, chunk quantity: ${worldData.length}"); //DEBUG
    int chunkPosition = 1;
    //Chunk Render Calculation Variables
    final chunkNegativeCalculation = (480 * calculateChunkNegative(chunkSquareRoot.toString())); //Calculates the negative side of the chunk
    double startX = calculateStartCoordinate((playerPosition[0] - chunkNegativeCalculation).round()); //Calculates the First X chunk coordinate to start rendering
    double startY = calculateStartCoordinate((playerPosition[1] - chunkNegativeCalculation).round()); //Calculates the First Y chunk coordinate to start rendering
    double actualStartX = startX; //Actual chunk that is rendering
    double actualStartY = startY; //Actual chunk that is rendering
    // print("Starting Render Position: $startX, $startY"); //DEBUG
    // print("Player Position: $playerPosition"); //DEBUG
    //Swipe all chunks
    for (int chunkIndex = 0; chunkIndex < chunkSquareRoot * chunkSquareRoot; chunkIndex++) {
      // print("Rendering the chunk: $chunkIndex"); //DEBUG
      //Checking the actual positiion of chunk to see if we need to down the position
      if (chunkPosition > chunkSquareRoot) {
        //Reseting the position
        chunkPosition = 1;
        //Reseting the base X because we finished the X chunks now we are going lower
        startX = calculateStartCoordinate((playerPosition[0] - chunkNegativeCalculation).round());
        actualStartX = startX;
        //Incresing the base Y because the X is finished and we need to go lower in the coordinates
        actualStartY += 480;
        startY = actualStartY;
      }
      // print("Chunk render startX: $startX, startY: $startY"); //DEBUG
      //Increase the chunk position
      chunkPosition++;
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
        //Swiping the X from the chunk
        for (int x = 0; x < actualTiles[y].length; x++) {
          // print("X: ${startX}, Y: ${startY}, tile: ${actualTiles[y][x]}"); //DEBUG
          //Create the component
          final component = WorldTile(
            worldTiles[actualTiles[y][x]]["tileSprite"].toString(),
            Vector2(double.parse(worldTiles[actualTiles[y][x]]["tileWidth"].toString()), double.parse(worldTiles[actualTiles[y][x]]["tileHeight"].toString())),
            Vector2(startX, startY),
          );
          //Adding to the world
          gameController.add(component);
          //Adding to the tiles rendered
          tilesRendered.add(component);
          startX += 32;
        }
        //Reseting the X to render the lower tiles
        startX = actualStartX;
        //Incresing the Y to render lower tiles
        startY += 32;
      }
      actualStartX += 480;
      startX = actualStartX;
      startY = actualStartY;
    }
    worldComponents = tilesRendered;
  }

  ///Removes all Components in the list from the render
  Future<bool> removeAllComponents(World gameController) async {
    for (int i = 0; i < worldComponents.length; i++) {
      gameController.remove(worldComponents[i]);
    }
    return true;
  }
}

class WorldTile extends SpriteComponent {
  //Declaration
  final String tileSprite;
  final Vector2 tileSize;
  final Vector2 tilePosition;

  late bool tileIsSolid;

  WorldTile(
      //Request
      this.tileSprite,
      this.tileSize,
      this.tilePosition
      //Setting
      )
      : super(
          size: tileSize,
          position: tilePosition,
        );

  @override
  Future<void> onLoad() async {
    //Load Sprite
    sprite = await Sprite.load(tileSprite);
  }
}
