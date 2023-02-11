import 'package:flutter/material.dart';

class BattleScene extends StatefulWidget {
  const BattleScene({super.key});

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        body: Column(
          children: [
            //Life and Mana
            SizedBox(
              width: screenSize.width,
              height: screenSize.height * 0.2,
              child: FittedBox(
                child: Row(
                  children: const [
                    Text(
                      'Life: null',
                      style: TextStyle(fontFamily: 'PressStart', fontSize: 500),
                    ),
                    SizedBox(width: 1500),
                    Text(
                      'Mana: null',
                      style: TextStyle(fontFamily: 'PressStart', fontSize: 500),
                    ),
                  ],
                ),
              ),
            ),
            //Image
            FittedBox(
              child: Container(
                color: Colors.white,
                width: screenSize.width,
                height: screenSize.height * 0.45,
                child: Stack(
                  children: [
                    //Background image
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height * 0.45,
                      child: Image.asset(
                          'assets/locations/prologue/paradise.png',
                          fit: BoxFit.cover),
                    ),
                    //Enemy image
                    Center(
                      child: Image.asset(
                          'assets/images/enemys/infight/small_spider.png'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
