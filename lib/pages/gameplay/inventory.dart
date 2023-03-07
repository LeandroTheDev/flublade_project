import 'package:flublade_project/components/item_widget.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameplayInventory extends StatefulWidget {
  const GameplayInventory({super.key});

  @override
  State<GameplayInventory> createState() => _GameplayInventoryState();
}

class _GameplayInventoryState extends State<GameplayInventory>
    with SingleTickerProviderStateMixin {
  bool hideEquips = true;
  //Animation Variables
  AnimationController? _controller;
  Animation<Size>? _heightController;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    _heightController = Tween(
      begin: const Size(double.infinity, 700),
      end: const Size(double.infinity, 0),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    //Update Screen
    _heightController?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void unequipItem() {}

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Show or Hide Equips
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          hideEquips = !hideEquips;
                          if (!hideEquips) {
                            _controller?.forward();
                          } else {
                            _controller?.reverse();
                          }
                        });
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: hideEquips
                            ? Image.asset('assets/images/interface/hide.png')
                            : Image.asset('assets/images/interface/show.png'),
                      )),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _heightController!,
                builder: (context, child) => //Equips
                    Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                      height: _heightController?.value.height ?? 0,
                      child: child),
                ),
                child: FittedBox(
                  child: Column(
                    children: [
                      //Hat
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 20),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 30),
                          //Hat
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                  'assets/images/interface/equipHead.png'),
                            ),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                      //Spacer
                      const SizedBox(height: 35),
                      //Shoulder & Necklace
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 20),
                          //Shoulder
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipShoulder1.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Necklace
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipNecklace.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Shoulder
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipShoulder2.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                      //Spacer
                      const SizedBox(height: 35),
                      //Hands & Chest
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 30),
                          //Hands
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipHands1.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Chest
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipChest.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Null
                          //Hands
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipHands2.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                      //Spacer
                      const SizedBox(height: 35),
                      //Leggings & Belt
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 20),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 30),
                          //Legs
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipLegs.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Belt
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipBelt.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 35),
                      //Shoes
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 30),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 30),
                          //Shoes
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equipShoes.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                      //Weapons
                      Row(
                        children: [
                          //Spacer
                          const SizedBox(width: 30),
                          //Weapon 1
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equip1.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 30),
                          //Null
                          const SizedBox(width: 150),
                          //Spacer
                          const SizedBox(width: 30),
                          //Weapon 2
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/images/interface/equip2.png'),
                          ),
                          //Spacer
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Items
              FutureBuilder(
                future: MySQL.returnPlayerInventory(context),
                builder: (context, future) {
                  if (future.data == true) {
                    List inventory = [];
                    //Tranforming Inventory in List to use index
                    gameplay.playerInventory
                        .forEach((key, value) => inventory.add(value));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      //Grid
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        shrinkWrap: true,
                        itemCount: gameplay.playerInventory.length,
                        itemBuilder: (context, index) {
                          //Single Item
                          return ItemWidget(
                              itemName: inventory[index]['name'],
                              itemQuantity:
                                  inventory[index]['quantity'].toString());
                        },
                      ),
                    );
                    //If inventory is empty
                  } else if (future.data == false) {
                    return const SizedBox();
                    //Loading
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ));
  }
}
