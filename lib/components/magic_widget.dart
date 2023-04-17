import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MagicWidget extends StatelessWidget {
  const MagicWidget({this.skillIndex = '', super.key});
  final String skillIndex;

  @override
  Widget build(BuildContext context) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);

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
                  gameplay.playerSkills[skillIndex]['image'],
                  fit: BoxFit.contain,
                )),
            gameplay.playerSkills[skillIndex]['type'] == 'none'
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
                                'assets/skills/${gameplay.playerSkills[skillIndex]['type']}Indicator.png',
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
