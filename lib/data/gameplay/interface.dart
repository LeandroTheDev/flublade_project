import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
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
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
      child: FittedBox(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              SizedBox(
                width: screenSize.width,
                height: screenSize.height * 0.10,
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
                      //Pause Button
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
              const Spacer(),
              gameplay.isTalkable
                  //Talk Button
                  ? SizedBox(
                      width: screenSize.width,
                      child: Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
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
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
