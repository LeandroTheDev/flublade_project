import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleScene extends StatefulWidget {
  const BattleScene({super.key});

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context);
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: FutureBuilder(
        future: null,
        builder: (context, future) {
          if (future.hasData) {
            return Column(
              children: [
                //Life and Mana
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.2,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 250.0),
                      child: Row(
                        children: [
                          //Life
                          Text(
                            'Life: ${gameplay.playerLife}',
                            style: const TextStyle(
                                fontFamily: 'PressStart', fontSize: 500),
                          ),
                          const SizedBox(width: 1500),
                          //Mana
                          Text(
                            'Mana: ${gameplay.playerMana}',
                            style: const TextStyle(
                                fontFamily: 'PressStart', fontSize: 500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Image
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.45,
                  child: Stack(
                    children: [
                      //Background image
                      SizedBox(
                        width: screenSize.width,
                        height: screenSize.height * 0.45,
                        child: Image.asset(
                            'assets/locations/prologue/paradise.png',
                            fit: BoxFit.cover),
                      ),
                      //Enemy image
                      Center(
                        child: Image.asset(
                            'assets/images/enemys/infight/small_spider.png'),
                      ),
                    ],
                  ),
                ),
                //Buttons
                SizedBox(
                  height: screenSize.height * 0.30,
                  width: screenSize.width,
                  child: Column(
                    children: [
                      const Spacer(),
                      //Attack & Defence
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: screenSize.width,
                        height: screenSize.height * 0.2,
                        child: FittedBox(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Attack'),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Defence'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      //Inventory & Magics
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
                                  width: 70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(Icons.inventory_2_outlined),
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.3,
                              ),
                              //Magics
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/inventory');
                                },
                                child: Container(
                                  width: 70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(Icons.menu_book),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          //Loading Widget
          } else {
            return Center(
                child: SizedBox(
              width: screenSize.width,
              height: screenSize.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FittedBox(
                  child: Column(
                    children: [
                      //Circular Loading
                      const CircularProgressIndicator(),
                      //Loading Please Wait
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          Language.Translate(
                                  'response_loading', options.language) ??
                              'Loading Please Wait',
                          style: const TextStyle(fontFamily: 'PressStart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
        },
      )),
    );
  }
}
