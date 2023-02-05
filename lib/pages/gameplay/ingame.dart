import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/gameplay/characters.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGame extends StatelessWidget {
  const InGame({super.key});

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      //Level Load
      future: MySQL.returnLevel(
        context,
        level: MySQL.returnInfo(context, returned: 'location'),
      ),
      builder: (context, future) {
        if (future.hasData) {
          return Stack(children: [
            //Gameplay
            BonfireWidget(
              // showCollisionArea: true,
              joystick: Joystick(
                directional: JoystickDirectional(),
              ),
              //Generate Map
              map: MatrixMapGenerator.generate(
                axisInverted: true,
                //Load Tiles Position
                matrix: future.data!,
                //Load Tiles Images
                builder: (ItemMatrixProperties prop) =>
                    Gameplay.loadTiles(prop),
              ),
              player: PlayerClient(
                Vector2(32, 32),
                context,
              ),
            ),
            //UI
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenSize.height * 0.05,
                  ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 65, horizontal: 20),
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
          //Loading Widget
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
