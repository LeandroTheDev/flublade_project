import 'package:flublade_project/data/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MagicWidget extends StatelessWidget {
  const MagicWidget({required this.name, this.isPassive = false, this.isDebuffs = false, this.debuffIndex = 0, super.key});
  final String name;
  final bool isPassive;
  final bool isDebuffs;
  final int debuffIndex;

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Returns type
    String typeFunction() {
      if (isPassive) {
        return 'none';
      } else if (isDebuffs) {
        return 'none';
      } else {
        return gameplay.playerSkills[name]['type'];
      }
    }

    //Returns image
    String returnImage() {
      if (isPassive) {
        return gameplay.playerBuffs[name]['image'];
      } else if (isDebuffs) {
        return gameplay.playerDebuffs[0]['image'];
      } else {
        return gameplay.playerSkills[name]['image'];
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
                  returnImage(),
                  fit: BoxFit.contain,
                )),
            //Damage Type
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
            //Stack Size & Rounds
            isDebuffs
                ? Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            //Stack
                            gameplay.playerDebuffs[debuffIndex]['stack'] <= 1
                                ? const SizedBox()
                                : Stack(
                                    children: [
                                      Text(
                                        '${gameplay.playerDebuffs[debuffIndex]['stack'].toString()}x',
                                        style: TextStyle(
                                          fontSize: 90,
                                          fontFamily: 'PressStart',
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 3
                                            ..color = Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${gameplay.playerDebuffs[debuffIndex]['stack'].toString()}x',
                                        style: const TextStyle(fontFamily: 'PressStart', fontSize: 90),
                                      ),
                                    ],
                                  ),
                            //Rounds
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Text(
                                    gameplay.playerDebuffs[debuffIndex]['rounds'].toString(),
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontFamily: 'PressStart',
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = Colors.white,
                                    ),
                                  ),
                                  Text(
                                    gameplay.playerDebuffs[debuffIndex]['rounds'].toString(),
                                    style: const TextStyle(fontFamily: 'PressStart', fontSize: 60),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
