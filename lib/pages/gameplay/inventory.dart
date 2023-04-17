import 'package:flublade_project/components/item_widget.dart';
import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/gameplay/skills.dart';
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

  //Show Player Stats Dialog
  void playerStats() {
    final settings = Provider.of<Settings>(context, listen: false);
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                Language.Translate(
                        'response_stats',
                        Provider.of<Options>(context, listen: false)
                            .language) ??
                    'Stats',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 40),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Life
                  Text(
                    '${Language.Translate('battle_life', Provider.of<Options>(context, listen: false).language) ?? 'Life'}: ${Provider.of<Gameplay>(context, listen: false).playerLife.toStringAsFixed(2)} / ${ClassAtributes.classTranslation(context: context, playerMaxLifeCalculationInGeneral: true).toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Mana
                  Text(
                    '${Language.Translate('battle_mana', Provider.of<Options>(context, listen: false).language) ?? 'Mana'}: ${Provider.of<Gameplay>(context, listen: false).playerMana}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Strength
                  Text(
                    '${Language.Translate('response_strength', Provider.of<Options>(context, listen: false).language) ?? 'Strength'}: ${Provider.of<Gameplay>(context, listen: false).playerStrength}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Agility
                  Text(
                    '${Language.Translate('response_agility', Provider.of<Options>(context, listen: false).language) ?? 'Agility'}: ${Provider.of<Gameplay>(context, listen: false).playerAgility}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Intelligence
                  Text(
                    '${Language.Translate('response_intelligence', Provider.of<Options>(context, listen: false).language) ?? 'Intelligence'}: ${Provider.of<Gameplay>(context, listen: false).playerIntelligence}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Armor
                  Text(
                    '${Language.Translate('response_armor', Provider.of<Options>(context, listen: false).language) ?? 'Armor'}: ${Provider.of<Gameplay>(context, listen: false).playerArmor}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Damage
                  Text(
                    '${Language.Translate('response_damage', Provider.of<Options>(context, listen: false).language) ?? 'Damage'}: ${ClassAtributes.classTranslation(
                      context: context,
                      playerDamageCalculationInStats: true,
                    )}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Level
                  Text(
                    '${Language.Translate('characters_create_level', Provider.of<Options>(context, listen: false).language) ?? 'Level'}: ${Provider.of<Gameplay>(context, listen: false).playerLevel}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Experience
                  Text(
                    '${Language.Translate('battle_loot_experience', Provider.of<Options>(context, listen: false).language) ?? 'Experience'} ${Provider.of<Gameplay>(context, listen: false).playerXP.toStringAsFixed(2)} / ${settings.levelCaps[Provider.of<Gameplay>(context, listen: false).playerLevel.toString()]!.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 30),
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
    final options = Provider.of<Options>(context);
    final screenSize = MediaQuery.of(context).size;

    //Equiped Item Image
    String showItem({required int index, required String defaultImage}) {
      if (gameplay.playerEquips[index] != 'none') {
        return Items.list[gameplay.playerEquips[index]]['image'];
      }
      return defaultImage;
    }

    //Show Unequip Items Dialog
    void unequipItem(itemName, equipIndex) {
      String itemTranslation;
      //Translate
      if (Language.Translate('items_${itemName}_desc', 'en_US') == null) {
        itemTranslation = itemName.substring(0, itemName.length - 2);
      } else {
        itemTranslation = itemName;
      }
      //Verify if tier is 0
      String verifyTier(itemName) {
        if (Items.returnTier(itemName) == '0') {
          return '';
        } else {
          return '+${Items.returnTier(itemName)}';
        }
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
                  '${Language.Translate('response_unequip', Provider.of<Options>(context, listen: false).language) ?? 'Unequip item'} ${Language.Translate('items_$itemTranslation', options.language) ?? 'Item Name'} ${verifyTier(itemName)}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 40),
                ),
                //Desc & Buttons
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Damage Stats
                    Items.list[itemName]['damage'] != null
                        ? Text(
                            '${Language.Translate('response_damage', Provider.of<Options>(context, listen: false).language) ?? 'Sell Price'}: ${Items.list[itemName]['damage']}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 30),
                          )
                        : const SizedBox(),
                    //Price Stats
                    Items.list[itemName]['price'] != null
                        ? Text(
                            '${Language.Translate('response_sellprice', Provider.of<Options>(context, listen: false).language) ?? 'Sell Price'}: ${Items.list[itemName]['price']}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 30),
                          )
                        : const SizedBox(),
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
                                //Adding in the inventory
                                Provider.of<Gameplay>(context, listen: false)
                                    .addSpecificItemInventory(itemName);
                                //Removing from equipments
                                Provider.of<Gameplay>(context, listen: false)
                                    .changePlayerEquips('none', equipIndex);
                                await MySQL.pushUploadCharacters(
                                    context: context);

                                setState(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
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

    //Compare Item Info
    void compareItemInfo(String itemName) {
      showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.0),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SizedBox(
              height: screenSize.height * 0.7,
              child: Column(
                children: [
                  //Comparation text
                  SizedBox(
                    height: screenSize.height * 0.1,
                    child: FittedBox(
                      child: Text(
                        Language.Translate(
                                'response_comparation',
                                Provider.of<Options>(context, listen: false)
                                    .language) ??
                            'Compare',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 200),
                      ),
                    ),
                  ),
                  //Divider
                  SizedBox(
                    height: screenSize.height * 0.02,
                    child: Divider(color: Theme.of(context).primaryColor),
                  ),
                  //Equipped Text
                  Container(
                    height: screenSize.height * 0.06,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        Language.Translate(
                                'response_equipped',
                                Provider.of<Options>(context, listen: false)
                                    .language) ??
                            'Equipped',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 200),
                      ),
                    ),
                  ),
                  //Damage Text
                  Items.list[itemName]['damage'] != null
                      ? Container(
                          height: screenSize.height * 0.06,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              '${Language.Translate('response_damage', Provider.of<Options>(context, listen: false).language) ?? 'Damage'}: ${Items.list[gameplay.playerEquips[Items.translateEquipsIndex(Items.list[itemName]['equip'])]]['damage']}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 200),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  //Divider
                  SizedBox(
                    height: screenSize.height * 0.02,
                    child: Divider(color: Theme.of(context).primaryColor),
                  ),
                  //Inventory Text
                  Container(
                    height: screenSize.height * 0.06,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        Language.Translate(
                                'response_inventory',
                                Provider.of<Options>(context, listen: false)
                                    .language) ??
                            'Equipped',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 200),
                      ),
                    ),
                  ),
                  //Damage Text
                  Items.list[itemName]['damage'] != null
                      ? Container(
                          height: screenSize.height * 0.06,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              '${Language.Translate('response_damage', Provider.of<Options>(context, listen: false).language) ?? 'Damage'}: ${Items.list[itemName]['damage']}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 200),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          });
    }

    //Show Item Infos
    void showItemInfo(String itemName) async {
      String itemTranslation;
      //Translate
      if (Language.Translate('items_${itemName}_desc', 'en_US') == null) {
        itemTranslation = itemName.substring(0, itemName.length - 2);
      } else {
        itemTranslation = itemName;
      }
      //Verify if tier is 0
      String verifyTier(itemName) {
        if (Items.returnTier(itemName) == '0') {
          return '';
        } else {
          return '+${Items.returnTier(itemName)}';
        }
      }

      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            //Gold Special
            if (Items.list[itemName]['name'] == 'gold') {
              return FittedBox(
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  //Title
                  title: Text(
                    Language.Translate(
                            'items_$itemTranslation', options.language) ??
                        'Item Name',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 40),
                  ),
                  //Desc & Buttons
                  content: SizedBox(
                    width: screenSize.width,
                    height: 400,
                    child: Column(
                      children: [
                        //Desc & Stats
                        SizedBox(
                          height: 300,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Desc
                                Text(
                                  Language.Translate(
                                          'items_${itemTranslation}_desc',
                                          options.language) ??
                                      'Item Description',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Buttons
                        FittedBox(
                          child: Row(
                            children: [
                              //Back
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    Language.Translate('response_back',
                                            options.language) ??
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
                ),
              );
            }
            return FittedBox(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Title
                title: Text(
                  '${Language.Translate('items_$itemTranslation', options.language) ?? 'Item Name'} ${verifyTier(itemName)}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 40),
                ),
                //Desc & Buttons
                content: SizedBox(
                  width: screenSize.width,
                  height: Items.list[itemName]['equip'] != 'none' ? 450 : 400,
                  child: Column(
                    children: [
                      //Desc & Stats
                      SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Desc
                              Text(
                                Language.Translate(
                                        'items_${itemTranslation}_desc',
                                        options.language) ??
                                    'Item Description',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 30),
                              ),
                              const SizedBox(height: 10),
                              //Weapon Widget
                              Items.list[itemName]['equip'] == '1weapon'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Language.Translate('response_damage', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['damage']}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30),
                                        ),
                                        Text(
                                          '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['price']}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              //Misc Widget
                              Items.list[itemName]['equip'] == 'none'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['price']}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      //Spacer
                      const SizedBox(height: 20),
                      //Buttons
                      FittedBox(
                        child: Row(
                          children: [
                            //Equip
                            Items.list[itemName]['equip'] != 'none'
                                ? SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        //Loading Widget
                                        MySQL.loadingWidget(
                                            context: context,
                                            language: options.language);
                                        //Removing from inventory
                                        Provider.of<Gameplay>(context,
                                                listen: false)
                                            .removeSpecificItemInventory(
                                                itemName);
                                        //Adding in the equipment
                                        gameplay.changePlayerEquips(
                                          itemName,
                                          Items.translateEquipsIndex(
                                              Items.list[itemName]['equip']),
                                        );
                                        //Change the damage
                                        gameplay.changePlayerDamage(
                                            Items.list[itemName]['damage']);
                                        await MySQL.pushUploadCharacters(
                                            context: context);
                                        setState(() {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        Language.Translate('response_equip',
                                                options.language) ??
                                            'Language Error',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 30),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            //Spacer
                            Items.list[itemName]['equip'] != 'none'
                                ? const SizedBox(width: 50)
                                : const SizedBox(),
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
                                          'response_back', options.language) ??
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
                      //Compare
                      Items.list[itemName]['equip'] != 'none'
                          ? gameplay.playerEquips[Items.translateEquipsIndex(
                                      Items.list[itemName]['equip'])] !=
                                  'none'
                              //Enabled Button
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: FittedBox(
                                    child: SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          compareItemInfo(itemName);
                                        },
                                        child: Text(
                                          Language.Translate('response_compare',
                                                  options.language) ??
                                              'Compare',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              //Blocked Button
                              : Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: FittedBox(
                                    child: SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        child: Text(
                                          Language.Translate('response_compare',
                                                  options.language) ??
                                              'Compare',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          });
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => playerStats(),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                              'assets/images/interface/equip_button.png'),
                        ),
                      ),
                      TextButton(
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
                        ),
                      ),
                    ],
                  ),
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
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.asset(
                                          showItem(
                                              index: 9,
                                              defaultImage:
                                                  'assets/images/interface/equip1.png'),
                                        ),
                                      ),
                                      //Tier
                                      Items.returnTier(
                                                  gameplay.playerEquips[9]) ==
                                              '0'
                                          ? const SizedBox()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0, left: 55.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      Items.returnTier(gameplay
                                                          .playerEquips[9]),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'PressStart',
                                                        letterSpacing: 5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        foreground: Paint()
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeWidth = 1
                                                          ..color =
                                                              Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      Items.returnTier(gameplay
                                                          .playerEquips[9]),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        letterSpacing: 5,
                                                        fontFamily:
                                                            'PressStart',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
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
                    if (future.data == 'Success') {
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
                            return TextButton(
                              onPressed: () {
                                showItemInfo(inventory[index]['name']);
                              },
                              child: ItemWidget(
                                  itemName: inventory[index]['name'],
                                  itemQuantity:
                                      inventory[index]['quantity'].toString()),
                            );
                          },
                        ),
                      );
                      //If inventory is empty
                    } else if (future.data == 'Empty') {
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
