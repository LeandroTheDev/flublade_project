import 'package:flublade_project/components/magic_widget.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Magics extends StatelessWidget {
  const Magics({super.key});

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    List skills = [];
    gameplay.playerSkills.forEach((key, value) => skills.add(value));
    List buffs = [];
    gameplay.playerBuffs.forEach((key, value) => buffs.add(value));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.Translate('response_magics', options.language) ?? 'Magics',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //Skills Text
          SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.1,
            child: FittedBox(
              child: Text(
                Language.Translate('response_skills', options.language) ?? 'Skills',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          //Grid Skills
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            shrinkWrap: true,
            itemCount: gameplay.playerSkills.length,
            itemBuilder: (context, index) {
              return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => FittedBox(
                              child: AlertDialog(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                title: Text(
                                  Language.Translate('magics_${skills[index]['name']}', options.language) ?? 'Language Error',
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                content: SizedBox(
                                  width: 300,
                                  height: 200,
                                  child: Column(
                                    children: [
                                      //Description
                                      SizedBox(
                                        height: 150,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                Language.Translate('magics_${skills[index]['name']}_desc', options.language) ?? 'Language Error',
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      //Select Button
                                      SizedBox(
                                        width: 200,
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              gameplay.changePlayerSelectedSkill(skills[index]['name']);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: FittedBox(
                                                child: Text(
                                              Language.Translate('response_select', options.language) ?? 'Select',
                                              style: const TextStyle(fontSize: 20),
                                            ))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: MagicWidget(
                    name: skills[index]['name'],
                  ));
            },
          ),
          //Passives Text
          SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.1,
            child: FittedBox(
              child: Text(
                Language.Translate('response_passives', options.language) ?? 'Passives',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          //Grid Passives
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            shrinkWrap: true,
            itemCount: gameplay.playerBuffs.length,
            itemBuilder: (context, index) {
              return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => FittedBox(
                              child: AlertDialog(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                title: Text(
                                  Language.Translate('magics_${buffs[index]['name']}', options.language) ?? 'Language Error',
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                content: SizedBox(
                                  width: 300,
                                  height: 200,
                                  child: Column(
                                    children: [
                                      //Description
                                      SizedBox(
                                        height: 150,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                Language.Translate('magics_${buffs[index]['name']}_desc', options.language) ?? 'Language Error',
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: MagicWidget(
                    name: buffs[index]['name'],
                    isPassive: true,
                  ));
            },
          ),
        ]),
      ),
    );
  }
}
