import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LootWidget extends StatefulWidget {
  const LootWidget(
      {required this.loots,
      required this.index,
      required this.color,
      super.key});
  final List loots;
  final int index;
  final List<Color> color;

  @override
  State<LootWidget> createState() => _LootWidgetState();
}

class _LootWidgetState extends State<LootWidget> {
  bool isPickup = false;

  @override
  Widget build(BuildContext context) {
    return isPickup
        ? TextButton(
            onPressed: null,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color[widget.index],
                borderRadius: BorderRadius.circular(10),
              ),
              width: 100,
              height: 65,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(Language.Translate('battle_loot_selected',
                            Provider.of<Options>(context).language) ??
                        'Selected'),
                  ),
                ),
              ),
            ),
          )
        : TextButton(
            onPressed: () {
              Provider.of<Gameplay>(context, listen: false)
                  .addPlayerInventorySelected(widget.loots[widget.index]);
              setState(() {
                isPickup = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: widget.color[widget.index],
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
                          Items.list[widget.loots[widget.index]['name']]
                              ['image'],
                          fit: BoxFit.fill,
                        ),
                      )),
                  FittedBox(
                    child: Text(
                      widget.loots[widget.index]['quantity'].toString(),
                      style: TextStyle(
                          fontFamily: 'PressStart',
                          fontSize: 10,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
