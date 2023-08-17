import 'package:flublade_project/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({required this.itemName, required this.itemQuantity, super.key});
  final String itemName;
  final String itemQuantity;

  @override
  Widget build(BuildContext context) {
    const itemColor = Colors.grey;
    final settings = Provider.of<Settings>(context, listen: false);
    final itemTier = Settings.itemTier(itemName);

    return FittedBox(
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
                        settings.lootImage(itemName),
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
                style: TextStyle(fontFamily: 'PressStart', fontSize: 20, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
