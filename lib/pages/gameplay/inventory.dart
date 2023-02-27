import 'package:flublade_project/components/item_widget.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameplayInventory extends StatelessWidget {
  const GameplayInventory({super.key});

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context);
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: MySQL.returnPlayerInventory(context),
          builder: (context, future) {
            if (future.data == true) {
              List inventory = [];
              //Tranforming Inventory in List to use index
              gameplay.playerInventory
                  .forEach((key, value) => inventory.add(value));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  shrinkWrap: true,
                  itemCount: gameplay.playerInventory.length,
                  itemBuilder: (context, index) {
                    return ItemWidget(
                        itemName: inventory[index]['name'],
                        itemQuantity: inventory[index]['quantity'].toString());
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
