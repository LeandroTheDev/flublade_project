import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngameInterface extends StatefulWidget {
  const IngameInterface({super.key});

  @override
  State<IngameInterface> createState() => _IngameInterfaceState();
}

class _IngameInterfaceState extends State<IngameInterface> {
  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context);
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
      child: FittedBox(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              SizedBox(
                width: screenSize.width,
                child: Row(
                  children: [
                    //Inventory
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/inventory');
                      },
                      child: Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.inventory_2_outlined),
                      ),
                    ),
                    const Spacer(),
                    //Pause Button
                    TextButton(
                      onPressed: () {
                        GlobalFunctions.pauseDialog(
                            context: context, options: options);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.pause),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              gameplay.isTalkable
              //Talk Button
                  ? SizedBox(
                    width: screenSize.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: TextButton(
                              onPressed: () {
                                Gameplay.showTalkText(context, 'test');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const FittedBox(child: Icon(Icons.comment_outlined)),
                              ),
                            ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
