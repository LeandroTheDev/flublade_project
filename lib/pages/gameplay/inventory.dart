import 'package:flublade_project/components/item_widget.dart';
import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/language.dart';

class GameplayInventory extends StatefulWidget {
  const GameplayInventory({super.key});

  @override
  State<GameplayInventory> createState() => _GameplayInventoryState();
}

class _GameplayInventoryState extends State<GameplayInventory>
    with SingleTickerProviderStateMixin {
  bool hideEquips = true;

  void unequipItem(itemName, equipIndex) {
    String itemTranslation;
    if (Language.Translate('items_${itemName}_desc', 'en_US') == null) {
      itemTranslation = itemName.substring(0, itemName.length - 2);
    } else {
      itemTranslation = itemName;
    }
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Unequip item Text
              title: Text(
                Language.Translate(
                        'response_unequipitem',
                        Provider.of<Options>(context, listen: false)
                            .language) ??
                    'Unequip item',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 40),
              ),
              //Desc & Buttons
              content: Column(
                children: [
                  //Unequip Text
                  Text(
                    '${Language.Translate('response_unequip', Provider.of<Options>(context, listen: false).language) ?? 'Unequip item'} ${Language.Translate('items_$itemTranslation', Provider.of<Options>(context, listen: false).language) ?? 'Item Name'}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 40),
                  ),
                  //Spacer
                  const SizedBox(height: 40),
                  //Buttons
                  FittedBox(
                    child: Row(
                      children: [
                        //Unequip
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              MySQL.loadingWidget(
                                  context: context,
                                  language: Provider.of<Options>(context,
                                          listen: false)
                                      .language);
                              Provider.of<Gameplay>(context, listen: false)
                                  .changePlayerEquips('none', equipIndex);
                              await MySQL.pushUploadCharacters(
                                  context: context);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate(
                                      'response_unequip',
                                      Provider.of<Options>(context,
                                              listen: false)
                                          .language) ??
                                  'Unequip',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                        //Spacer
                        const SizedBox(width: 50),
                        //Back
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate(
                                      'response_back',
                                      Provider.of<Options>(context,
                                              listen: false)
                                          .language) ??
                                  'No',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);

    //Equiped Item Image
    String showItem({required int index, required String defaultImage}) {
      if (gameplay.playerEquips[index] != 'none') {
        return Items.list[gameplay.playerEquips[index]]['image'];
      }
      return defaultImage;
    }

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
              //Equips
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                height: hideEquips ? 0 : MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                height: 150,
                                width: 150,
                                child: TextButton(
                                  onPressed: () => gameplay.playerEquips[9] !=
                                          'none'
                                      ? unequipItem(gameplay.playerEquips[9], 9)
                                      : null,
                                  child: Image.asset(showItem(
                                      index: 9,
                                      defaultImage:
                                          'assets/images/interface/equip1.png')),
                                ),
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
                                child: Image.asset(showItem(
                                    index: 10,
                                    defaultImage:
                                        'assets/images/interface/equip2.png')),
                              ),
                              //Spacer
                              const SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //Items
              Center(
                child: FutureBuilder(
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
              ),
            ],
          ),
        ));
  }
}
