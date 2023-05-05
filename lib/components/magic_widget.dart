import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MagicWidget extends StatelessWidget {
  const MagicWidget({required this.name, this.isPassive = false, super.key});
  final String name;
  final bool isPassive;

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Returns type
    String typeFunction() {
      if (isPassive) {
        return 'none';
      } else {
        return gameplay.playerSkills[name]['type'];
      }
    }

    return FittedBox(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            //Image
            SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  isPassive ? gameplay.playerBuffs[name]['image'] : gameplay.playerSkills[name]['image'],
                  fit: BoxFit.contain,
                )),
            typeFunction() == 'none'
                ? const SizedBox()
                : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: //Image
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                'assets/skills/${gameplay.playerSkills[name]['type']}Indicator.png',
                                fit: BoxFit.contain,
                              )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
