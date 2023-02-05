import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/gameplay/characters.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGame extends StatelessWidget {
  const InGame({super.key});

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    return Stack(children: [
      BonfireWidget(
        joystick: Joystick(
          directional: JoystickDirectional(),
        ),
        map: WorldMapByTiled(
          'prologue/prologue.json',
          forceTileSize: Vector2(32, 32),
        ),
        player: PlayerClient(
          Vector2(16, 16),
          context,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Top Bar Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Inventory
                TextButton(
                  onPressed: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Icon(Icons.inventory_2_outlined),
                  ),
                ),
                //Pause
                TextButton(
                  onPressed: () {
                    GlobalFunctions.pauseDialog(
                        context: context, options: options);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.pause),
                  ),
                ),
              ],
            ),
            const Spacer(),
            //Down bar Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 20),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
