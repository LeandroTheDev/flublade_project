import 'package:flame/game.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';

class IngameInterface extends StatefulWidget {
  const IngameInterface({super.key});

  @override
  State<IngameInterface> createState() => _IngameInterfaceState();
}

class _IngameInterfaceState extends State<IngameInterface> {
  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);
    final settings = Provider.of<Settings>(context, listen: false);
    final engine = Provider.of<GameEngine>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;

    return FittedBox(
      child: SizedBox(
        height: screenSize.height,
        child: Column(
          children: [
            //Top Hud
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              width: screenSize.width,
              height: screenSize.height * 0.20,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Inventory
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/inventory');
                      },
                      child: Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const FittedBox(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.inventory_2_outlined),
                        )),
                      ),
                    ),
                    //Xp Bar
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: screenSize.width * 0.6,
                      height: screenSize.height * 0.1,
                      child: FittedBox(
                          child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.purple),
                              width: ((gameplay.playerXP / settings.levelCaps[gameplay.playerLevel.toString()]) * 100) * 5.74,
                              height: 90,
                            ),
                          ),
                          SizedBox(
                            width: 600,
                            height: 100,
                            child: Image.asset(
                              'assets/images/interface/xpBar.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )),
                    ),
                    // Pause Button
                    TextButton(
                      onPressed: () {
                        GlobalFunctions.pauseDialog(context: context);
                      },
                      child: Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const FittedBox(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.pause),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Camera Spacer
            SizedBox(height: screenSize.height * 0.5),
            //Joystick and Talk Button
            SizedBox(
              width: screenSize.width,
              height: screenSize.height * 0.3,
              child: Row(
                children: [
                  SizedBox(
                    width: screenSize.width * 0.45,
                    height: screenSize.height * 0.3,
                    child: FittedBox(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: JoystickArea(
                          listener: (area) {
                            //+x right -x left
                            //+y down -y up
                            engine.setjoystickPosition(Vector2(area.x, area.y));
                          },
                          initialJoystickAlignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  gameplay.isTalkable
                      //Talk Button
                      ? Container(
                          alignment: Alignment.centerRight,
                          width: screenSize.width * 0.55,
                          child: TextButton(
                            onPressed: () {
                              Gameplay.showTalkText(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const FittedBox(child: Icon(Icons.comment_outlined)),
                            ),
                          ),
                        )
                      : SizedBox(width: screenSize.width * 0.55),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
