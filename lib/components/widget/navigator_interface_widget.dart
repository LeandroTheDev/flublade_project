import 'package:flame/game.dart';
import 'package:flublade_project/components/connection_engine.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/navigator.dart';
import 'package:flublade_project/data/options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';

class NavigatorInterface extends StatefulWidget {
  final ConnectionEngine engine;
  const NavigatorInterface(this.engine, {super.key});

  @override
  State<NavigatorInterface> createState() => _NavigatorInterfaceState();
}

class _NavigatorInterfaceState extends State<NavigatorInterface> {
  bool isMoving = false;
  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);
    final navigator = Provider.of<NavigatorData>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;

    pauseDialog({
      required BuildContext context,
    }) {
      final options = Provider.of<Options>(context, listen: false);
      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            return FittedBox(
              child: AlertDialog(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  //Language Text
                  title: Text(
                    Language.Translate('pausemenu_pause', options.language) ?? 'Pause',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  content: Column(
                    children: [
                      //Continue
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(Language.Translate('pausemenu_continue', options.language) ?? 'Continue'),
                        ),
                      ),
                      //Options
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/optionsmenu');
                          },
                          child: Text(Language.Translate('pausemenu_options', options.language) ?? 'Options'),
                        ),
                      ),
                      //Disconnect
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.engine.closeNavigatorSocket();
                            Navigator.of(context).pushNamedAndRemoveUntil('/mainmenu', (route) => false);
                          },
                          child: Text(Language.Translate('pausemenu_disconnectIngame', options.language) ?? 'Disconnect'),
                        ),
                      ),
                    ],
                  )),
            );
          });
    }

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
                              width: 100, //((gameplay.playerXP / settings.levelCaps[gameplay.playerLevel.toString()]) * 100) * 5.74,
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
                        pauseDialog(context: context);
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
                            navigator.changeJoystickPosition(Vector2(area.x, area.y));
                            //Check if player is moving and stopped moving
                            if (isMoving && area.x == 0 && area.y == 0) {
                              isMoving = false;
                              //Update Animation
                              navigator.player.bodySprite.changeToIdle();
                            }
                            //Check if player is NOT moving and started moving
                            else if (!isMoving && area.x != 0 && area.y != 0) {
                              isMoving = true;
                              //Update Animation
                              navigator.player.bodySprite.changeToRunning();
                            }
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
