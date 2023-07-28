import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LootWidget extends StatefulWidget {
  const LootWidget({required this.loots, required this.index, super.key});
  final List loots;
  final int index;

  @override
  State<LootWidget> createState() => _LootWidgetState();
}

class _LootWidgetState extends State<LootWidget> {
  bool isPickup = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context, listen: false);

    return isPickup
        ? TextButton(
            onPressed: null,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 100,
              height: 65,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(Language.Translate('battle_loot_selected', Provider.of<Options>(context).language) ?? 'Selected'),
                  ),
                ),
              ),
            ),
          )
        : TextButton(
            onPressed: () {
              Provider.of<Gameplay>(context, listen: false).addPlayerInventorySelected(widget.loots[widget.index]);
              setState(() {
                isPickup = true;
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 100,
                  height: 65,
                  child: Column(
                    children: [
                      SizedBox(
                          width: 100,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              settings.lootImage(widget.loots[widget.index]['name']),
                              fit: BoxFit.fill,
                            ),
                          )),
                      FittedBox(
                        child: Text(
                          widget.loots[widget.index]['quantity'].toString(),
                          style: TextStyle(fontFamily: 'PressStart', fontSize: 10, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                //Tier
                settings.itemTier(widget.loots[widget.index]['name']) == '0'
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, right: 5),
                          child: Stack(
                            children: [
                              Text(
                                settings.itemTier(widget.loots[widget.index]['name']),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'PressStart',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                settings.itemTier(widget.loots[widget.index]['name']),
                                style: const TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  fontFamily: 'PressStart',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
  }
}
