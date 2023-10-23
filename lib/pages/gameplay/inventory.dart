// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flublade_project/components/widget/item_widget.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../data/language.dart';

class GameplayInventory extends StatefulWidget {
  const GameplayInventory({super.key});

  @override
  State<GameplayInventory> createState() => _GameplayInventoryState();
}

class _GameplayInventoryState extends State<GameplayInventory> with SingleTickerProviderStateMixin {
  bool hideEquips = true;

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);
    final options = Provider.of<Options>(context);
    final server = Provider.of<Server>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    final settings = Provider.of<Settings>(context, listen: false);

    //Equiped Item Image
    String showItem({required int index, required String defaultImage}) {
      if (gameplay.playerEquips[index] != 'none') {
        return settings.itemsId[Settings.tierCheck(gameplay.playerEquips[index]['name'])]['image'];
      }
      return defaultImage;
    }

    //Show Unequip Items Dialog
    void unequipItem(item, equipIndex) {
      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            return FittedBox(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Unequip item Text
                title: Text(
                  '${Language.Translate('response_unequip', options.language) ?? 'Unequip item'} ${Language.Translate('items_${Settings.tierCheck(item['name'])}', options.language) ?? 'Item Name'} ${Settings.itemTier(item['name'], addPlus: true)}',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40),
                ),
                //Desc & Buttons
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Damage Stats
                    gameplay.playerEquips[equipIndex]['baseDamage'] != 0
                        ? Text(
                            '${Language.Translate('response_damage', options.language) ?? 'Sell Price'}: ${gameplay.playerEquips[equipIndex]['baseDamage']}',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                          )
                        : const SizedBox(),
                    //Price Stats
                    gameplay.playerEquips[equipIndex]['sell'] != 0
                        ? Text(
                            '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${gameplay.playerEquips[equipIndex]['sell']}',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
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
                                GlobalFunctions.loadingWidget(context: context, language: Provider.of<Options>(context, listen: false).language);
                                await http.post(Uri.http(server.serverAddress, '/changeEquip'),
                                    headers: Server.headers,
                                    body: jsonEncode({
                                      'id': options.id,
                                      'token': options.token,
                                      'equipped': 'none',
                                      'inventory': gameplay.playerInventory,
                                      'equips': gameplay.playerEquips,
                                      'selectedCharacter': gameplay.selectedCharacter,
                                      'index': equipIndex,
                                    }));
                                await Server.returnPlayerStats(context);
                                setState(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                Language.Translate('response_unequip', Provider.of<Options>(context, listen: false).language) ?? 'Unequip',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
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
                                Language.Translate('response_back', Provider.of<Options>(context, listen: false).language) ?? 'No',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
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
                        Language.Translate('response_comparation', options.language) ?? 'Compare',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 200),
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
                        Language.Translate('response_equipped', options.language) ?? 'Equipped',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 200),
                      ),
                    ),
                  ),
                  //Damage Text
                  settings.itemsId[Settings.tierCheck(itemName)]['damage'] != null
                      ? Container(
                          height: screenSize.height * 0.06,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              '${Language.Translate('response_damage', options.language) ?? 'Damage'}: ${settings.itemsId[gameplay.playerEquips[settings.translateEquipsIndex(settings.itemsId[Settings.tierCheck(itemName)]['equip'])[0]]]['damage']}',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 200),
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
                        Language.Translate('response_inventory', options.language) ?? 'Equipped',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 200),
                      ),
                    ),
                  ),
                  //Damage Text
                  settings.itemsId[Settings.tierCheck(itemName)]['damage'] != null
                      ? Container(
                          height: screenSize.height * 0.06,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              '${Language.Translate('response_damage', options.language) ?? 'Damage'}: ${settings.itemsId[Settings.tierCheck(itemName)]['damage']}',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 200),
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
      //Translate the item name
      String itemTranslation;
      if (Language.Translate('items_${Settings.tierCheck(itemName)}_desc', 'en_US') == null) {
        itemTranslation = itemName.substring(0, itemName.length - 2);
      } else {
        itemTranslation = Settings.tierCheck(itemName);
      }

      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            return FittedBox(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Title
                title: Text(
                  '${Language.Translate('items_$itemTranslation', options.language) ?? 'Item Name'} ${Settings.itemTier(itemName, addPlus: true)}',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40),
                ),
                //Desc & Buttons
                content: SizedBox(
                  width: screenSize.width,
                  height: gameplay.playerInventory[itemName]['equip'] != 'none' ? 450 : 400,
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
                                Language.Translate('items_${itemTranslation}_desc', options.language) ?? 'Item Description',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                              ),
                              const SizedBox(height: 40),
                              //Stats Widget
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Damage Text
                                  gameplay.playerInventory[itemName]['baseDamage'] != 0
                                      ? Text(
                                          '${Language.Translate('response_damage', options.language) ?? 'Sell Price'}: ${gameplay.playerInventory[itemName]['baseDamage']}',
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                                        )
                                      : const SizedBox(),
                                  //Sell Text
                                  gameplay.playerInventory[itemName]['sell'] != 0
                                      ? Text(
                                          '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${gameplay.playerInventory[itemName]['sell']}',
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
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
                            settings.itemsId[Settings.tierCheck(itemName)]['equip'] != 'none'
                                ? SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (settings.itemsId[Settings.tierCheck(itemName)]['equip'].length > 1) {
                                          showDialog(
                                              barrierColor: const Color.fromARGB(167, 0, 0, 0),
                                              context: context,
                                              builder: (context) {
                                                return FittedBox(
                                                  child: AlertDialog(
                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                    //Equip Text
                                                    title: Text(
                                                      '${Language.Translate('response_equip', options.language) ?? 'Equip'} ${Language.Translate('items_${Settings.tierCheck(itemName)}', options.language) ?? 'Language Error'} ${Settings.itemTier(itemName, addPlus: true)}',
                                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                                    ),
                                                    content: SizedBox(
                                                      width: 150,
                                                      height: 50,
                                                      child: Center(
                                                        child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: settings.itemsId[Settings.tierCheck(itemName)]['equip'].length,
                                                          itemBuilder: (context, index) => SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: ElevatedButton(
                                                                onPressed: () async {
                                                                  final selectedIndex = settings.itemsId[Settings.tierCheck(itemName)]['equip'][index];
                                                                  //Loading Widget
                                                                  GlobalFunctions.loadingWidget(context: context, language: options.language);
                                                                  //Equipped item variable
                                                                  final equipped = gameplay.playerInventory[itemName];
                                                                  //Add Equip Stats
                                                                  await http.post(Uri.http(server.serverAddress, '/changeEquip'),
                                                                      headers: Server.headers,
                                                                      body: jsonEncode({
                                                                        'id': options.id,
                                                                        'token': options.token,
                                                                        'equipped': equipped,
                                                                        'inventory': gameplay.playerInventory,
                                                                        'equips': gameplay.playerEquips,
                                                                        'selectedCharacter': gameplay.selectedCharacter,
                                                                        'index': selectedIndex,
                                                                      }));
                                                                  await Server.returnPlayerStats(context);
                                                                  setState(() {
                                                                    Navigator.pop(context);
                                                                    Navigator.pop(context);
                                                                    Navigator.pop(context);
                                                                  });
                                                                },
                                                                child: FittedBox(
                                                                  child: Text(
                                                                    Language.Translate('response_equipmentIndex_${settings.itemsId[Settings.tierCheck(itemName)]['equip'][index]}', options.language) ?? 'Language Error',
                                                                    style: const TextStyle(fontSize: 99),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          final selectedIndex = settings.itemsId[Settings.tierCheck(itemName)]['equip'][0];
                                          //Loading Widget
                                          GlobalFunctions.loadingWidget(context: context, language: options.language);
                                          //Equipped item variable
                                          final equipped = gameplay.playerInventory[itemName];
                                          //Add Equip Stats
                                          await http.post(Uri.http(server.serverAddress, '/changeEquip'),
                                              headers: Server.headers,
                                              body: jsonEncode({
                                                'id': options.id,
                                                'token': options.token,
                                                'equipped': equipped,
                                                'inventory': gameplay.playerInventory,
                                                'equips': gameplay.playerEquips,
                                                'selectedCharacter': gameplay.selectedCharacter,
                                                'index': selectedIndex,
                                              }));
                                          await Server.returnPlayerStats(context);
                                          setState(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text(
                                        Language.Translate('response_equip', options.language) ?? 'Language Error',
                                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            //Spacer
                            settings.itemsId[Settings.tierCheck(itemName)]['equip'] != 'none' ? const SizedBox(width: 50) : const SizedBox(),
                            //Back
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  Language.Translate('response_back', options.language) ?? 'No',
                                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Compare
                      settings.itemsId[Settings.tierCheck(itemName)]['equip'] != 'none'
                          ? gameplay.playerEquips[settings.itemsId[Settings.tierCheck(itemName)]['equip'][0]] != 'none'
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
                                          Language.Translate('response_compare', options.language) ?? 'Compare',
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
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
                                          Language.Translate('response_compare', options.language) ?? 'Compare',
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
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

    //Return equipment name by equip index
    String returnEquipName(index) {
      if (gameplay.playerEquips[index] == 'none') {
        return '';
      }
      return gameplay.playerEquips[index]['name'];
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
                        onPressed: () => GlobalFunctions.playerStats(context),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/interface/equipButton.png'),
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
                          child: hideEquips ? Image.asset('assets/images/interface/hide.png') : Image.asset('assets/images/interface/show.png'),
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
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  height: 150,
                                  width: 150,
                                  child: Image.asset('assets/images/interface/equipHead.png'),
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
                                child: Image.asset('assets/images/interface/equipShoulder1.png'),
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
                                child: Image.asset('assets/images/interface/equipNecklace.png'),
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
                                child: Image.asset('assets/images/interface/equipShoulder2.png'),
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
                                child: Image.asset('assets/images/interface/equipHands1.png'),
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
                                child: Image.asset('assets/images/interface/equipChest.png'),
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
                                child: Image.asset('assets/images/interface/equipHands2.png'),
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
                                child: Image.asset('assets/images/interface/equipLegs.png'),
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
                                child: Image.asset('assets/images/interface/equipBelt.png'),
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
                                child: Image.asset('assets/images/interface/equipShoes.png'),
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
                                  onPressed: () => gameplay.playerEquips[9] != 'none' ? unequipItem(gameplay.playerEquips[9], 9) : null,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.asset(
                                          showItem(index: 9, defaultImage: 'assets/images/interface/equip1.png'),
                                        ),
                                      ),
                                      //Tier
                                      Settings.itemTier(returnEquipName(9)) == '0'
                                          ? const SizedBox()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 3.0, left: 55.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      Settings.itemTier(returnEquipName(9)),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'PressStart',
                                                        letterSpacing: 5,
                                                        fontWeight: FontWeight.bold,
                                                        foreground: Paint()
                                                          ..style = PaintingStyle.stroke
                                                          ..strokeWidth = 1
                                                          ..color = Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      Settings.itemTier(returnEquipName(9)),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        letterSpacing: 5,
                                                        fontFamily: 'PressStart',
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                height: 150,
                                width: 150,
                                child: TextButton(
                                  onPressed: () => gameplay.playerEquips[10] != 'none' ? unequipItem(gameplay.playerEquips[10], 10) : null,
                                  child: Stack(
                                    children: [
                                      //Image
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.asset(
                                          showItem(index: 10, defaultImage: 'assets/images/interface/equip2.png'),
                                        ),
                                      ),
                                      //Tier
                                      Settings.itemTier(returnEquipName(10)) == '0'
                                          ? const SizedBox()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 3.0, left: 55.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      Settings.itemTier(returnEquipName(10)),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'PressStart',
                                                        letterSpacing: 5,
                                                        fontWeight: FontWeight.bold,
                                                        foreground: Paint()
                                                          ..style = PaintingStyle.stroke
                                                          ..strokeWidth = 1
                                                          ..color = Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      Settings.itemTier(returnEquipName(10)),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        letterSpacing: 5,
                                                        fontFamily: 'PressStart',
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
                  future: Server.returnPlayerInventory(context),
                  builder: (context, future) {
                    if (future.data == 'Success') {
                      List inventory = [];
                      //Tranforming Inventory in List to use index
                      gameplay.playerInventory.forEach((key, value) => inventory.add(value));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        //Grid
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              child: ItemWidget(itemName: inventory[index]['name'], itemQuantity: inventory[index]['quantity'].toString()),
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
