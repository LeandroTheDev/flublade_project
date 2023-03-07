import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {required this.itemName, required this.itemQuantity, super.key});
  final String itemName;
  final String itemQuantity;

  @override
  Widget build(BuildContext context) {
    final itemColor = Items.returnRarity(itemName);
    final itemTier = Items.returnTier(itemName);
    final gameplay = Provider.of<Gameplay>(context);
    final options = Provider.of<Options>(context);
    final screenSize = MediaQuery.of(context).size;

    final weaponDesc = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Language.Translate('response_damage', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['damage']}',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
        Text(
          '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['price']}',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
      ],
    );

    final miscDesc = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Language.Translate('response_sellprice', options.language) ?? 'Sell Price'}: ${Items.list[itemName]['price']}',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
      ],
    );

    void showItemInfo(String value) async {
      // final connection = await MySQL.database;
      String itemTranslation;
      if (Language.Translate('items_${value}_desc', 'en_US') == null) {
        itemTranslation = value.substring(0, value.length - 2);
      } else {
        itemTranslation = value;
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
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 300,
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
                        const SizedBox(height: 10),
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
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 300,
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
                                  ? weaponDesc
                                  : const SizedBox(),
                              //Misc Widget
                              Items.list[itemName]['equip'] == 'none'
                                  ? miscDesc
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      //Spacer
                      const SizedBox(height: 10),
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
                                        MySQL.loadingWidget(
                                            context: context,
                                            language: options.language);
                                        gameplay.changePlayerEquips(
                                          itemName,
                                          gameplay.translateEquipsIndex(
                                              Items.list[itemName]['equip']),
                                        );
                                        await MySQL.pushUploadCharacters(
                                            context: context);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
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
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return FittedBox(
      child: TextButton(
        onPressed: () async {
          showItemInfo(itemName);
        },
        child: Container(
          decoration: BoxDecoration(
            color: itemColor,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 100,
          height: 100,
          child: Column(
            children: [
              //Item Image & Tier
              Stack(
                children: [
                  //Image
                  SizedBox(
                      width: 100,
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          Items.list[itemName]['image'],
                          fit: BoxFit.fill,
                        ),
                      )),
                  //Item Tier
                  itemTier == '0'
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
                              children: [
                                Text(
                                  itemTier,
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
                                  itemTier,
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
              //Quantity Text
              FittedBox(
                child: Text(
                  itemQuantity,
                  style: TextStyle(
                      fontFamily: 'PressStart',
                      fontSize: 20,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
