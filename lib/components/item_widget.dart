import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {required this.itemName, required this.itemQuantity, super.key});
  final String itemName;
  final String itemQuantity;

  Color returnItemRarity() {
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: returnItemRarity(),
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
                    Items.list[itemName]['image'],
                    fit: BoxFit.fill,
                  ),
                )),
            FittedBox(
              child: Text(
                itemQuantity,
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
