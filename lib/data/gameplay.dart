import 'dart:convert';

import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Gameplay with ChangeNotifier {
  //Engine
  late Engine _engine;

  ///This provides the main functions to control the game connection and functions
  Engine get engine => _engine;

  ///All Classes ordened by ID
  static Map classes = {
    0: 'archer',
    1: 'assassin',
    2: 'bard',
    3: 'beastmaster',
    4: 'berserk',
    5: 'druid',
    6: 'mage',
    7: 'paladin',
    8: 'priest',
    9: 'trickmagician',
    10: 'weaponsmith',
    11: 'witch',
  };

  //All Races ordened by ID
  static Map races = {
    0: 'human',
    1: 'nature',
    2: 'dytol',
    3: 'aghars',
    4: 'dark',
    5: 'undead',
  };

  //All Body Options ordened by Race
  static Map bodyOptions = {
    'human': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/human/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/human/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/human/male_body_idle.png',
          'running0': 'assets/images/players/human/male_body_running0.png',
          'running1': 'assets/images/players/human/male_body_running1.png',
          'running2': 'assets/images/players/human/male_body_running2.png',
          'running3': 'assets/images/players/human/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/human/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/human/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/human/female_body_idle.png',
          'running0': 'assets/images/players/human/female_body_running0.png',
          'running1': 'assets/images/players/human/female_body_running1.png',
          'running2': 'assets/images/players/human/female_body_running2.png',
          'running3': 'assets/images/players/human/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/human/hair/hair0.png',
        1: 'assets/images/players/human/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/human/eyes/eyes0.png',
        1: 'assets/images/players/human/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/human/mouth/mouth0.png',
        1: 'assets/images/players/human/mouth/mouth1.png',
      },
    },
    'nature': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/nature/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/nature/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/nature/male_body_idle.png',
          'running0': 'assets/images/players/nature/male_body_running0.png',
          'running1': 'assets/images/players/nature/male_body_running1.png',
          'running2': 'assets/images/players/nature/male_body_running2.png',
          'running3': 'assets/images/players/nature/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/nature/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/nature/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/nature/female_body_idle.png',
          'running0': 'assets/images/players/nature/female_body_running0.png',
          'running1': 'assets/images/players/nature/female_body_running1.png',
          'running2': 'assets/images/players/nature/female_body_running2.png',
          'running3': 'assets/images/players/nature/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/nature/hair/hair0.png',
        1: 'assets/images/players/nature/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/nature/eyes/eyes0.png',
        1: 'assets/images/players/nature/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/nature/mouth/mouth0.png',
        1: 'assets/images/players/nature/mouth/mouth1.png',
      },
    },
    'dytol': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dytol/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/dytol/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dytol/male_body_idle.png',
          'running0': 'assets/images/players/dytol/male_body_running0.png',
          'running1': 'assets/images/players/dytol/male_body_running1.png',
          'running2': 'assets/images/players/dytol/male_body_running2.png',
          'running3': 'assets/images/players/dytol/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dytol/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/dytol/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dytol/female_body_idle.png',
          'running0': 'assets/images/players/dytol/female_body_running0.png',
          'running1': 'assets/images/players/dytol/female_body_running1.png',
          'running2': 'assets/images/players/dytol/female_body_running2.png',
          'running3': 'assets/images/players/dytol/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/dytol/hair/hair0.png',
        1: 'assets/images/players/dytol/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/dytol/eyes/eyes0.png',
        1: 'assets/images/players/dytol/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/dytol/mouth/mouth0.png',
        1: 'assets/images/players/dytol/mouth/mouth1.png',
      },
    },
    'aghars': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/aghars/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/aghars/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/aghars/male_body_idle.png',
          'running0': 'assets/images/players/aghars/male_body_running0.png',
          'running1': 'assets/images/players/aghars/male_body_running1.png',
          'running2': 'assets/images/players/aghars/male_body_running2.png',
          'running3': 'assets/images/players/aghars/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/aghars/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/aghars/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/aghars/female_body_idle.png',
          'running0': 'assets/images/players/aghars/female_body_running0.png',
          'running1': 'assets/images/players/aghars/female_body_running1.png',
          'running2': 'assets/images/players/aghars/female_body_running2.png',
          'running3': 'assets/images/players/aghars/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/aghars/hair/hair0.png',
        1: 'assets/images/players/aghars/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/aghars/eyes/eyes0.png',
        1: 'assets/images/players/aghars/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/aghars/mouth/mouth0.png',
        1: 'assets/images/players/aghars/mouth/mouth1.png',
      },
    },
    'dark': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dark/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/dark/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dark/male_body_idle.png',
          'running0': 'assets/images/players/dark/male_body_running0.png',
          'running1': 'assets/images/players/dark/male_body_running1.png',
          'running2': 'assets/images/players/dark/male_body_running2.png',
          'running3': 'assets/images/players/dark/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dark/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/dark/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dark/female_body_idle.png',
          'running0': 'assets/images/players/dark/female_body_running0.png',
          'running1': 'assets/images/players/dark/female_body_running1.png',
          'running2': 'assets/images/players/dark/female_body_running2.png',
          'running3': 'assets/images/players/dark/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/dark/hair/hair0.png',
        1: 'assets/images/players/dark/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/dark/eyes/eyes0.png',
        1: 'assets/images/players/dark/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/dark/mouth/mouth0.png',
        1: 'assets/images/players/dark/mouth/mouth1.png',
      },
    },
    'undead': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/undead/skin/0/male_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/undead/skin/1/male_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/undead/male_body_idle.png',
          'running0': 'assets/images/players/undead/male_body_running0.png',
          'running1': 'assets/images/players/undead/male_body_running1.png',
          'running2': 'assets/images/players/undead/male_body_running2.png',
          'running3': 'assets/images/players/undead/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/undead/skin/0/female_skin_idle.png',
          },
          1: {
            'idle': 'assets/images/players/undead/skin/1/female_skin_idle.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/undead/female_body_idle.png',
          'running0': 'assets/images/players/undead/female_body_running0.png',
          'running1': 'assets/images/players/undead/female_body_running1.png',
          'running2': 'assets/images/players/undead/female_body_running2.png',
          'running3': 'assets/images/players/undead/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/undead/hair/hair0.png',
        1: 'assets/images/players/undead/hair/hair1.png',
      },
      'eyes': {
        0: 'assets/images/players/undead/eyes/eyes0.png',
        1: 'assets/images/players/undead/eyes/eyes1.png',
      },
      'mouth': {
        0: 'assets/images/players/undead/mouth/mouth0.png',
        1: 'assets/images/players/undead/mouth/mouth1.png',
      },
    },
  };

  ///Return the asset location of the body option
  ///
  ///raceID = its the race id of the character, you can get by using Gameplay.races
  ///
  ///bodyOption = the specific option do you want for the body: (body, skin, hair, eyes...)
  ///
  ///gender = gender is only necessary for body and skin, false for male, true for female
  ///
  ///selectedOption = only necessary if you selecting a body option that uses int numbers like (hair, eyes, mouth, skin)
  ///
  ///selectedSprite = only for body option thats have multiples sprites (body, skin)
  static returnBodyOptionAsset({required int raceID, String bodyOption = "body", bool gender = false, int selectedOption = 0, selectedSprite = 'idle'}) {
    final characterGender = !gender ? 'male' : 'female';
    switch (bodyOption) {
      case 'body':
        return Gameplay.bodyOptions[Gameplay.races[raceID]][characterGender][bodyOption][selectedSprite];
      case 'skin':
        return Gameplay.bodyOptions[Gameplay.races[raceID]][characterGender][bodyOption][selectedOption][selectedSprite];
      case 'hair':
        return Gameplay.bodyOptions[Gameplay.races[raceID]][bodyOption][selectedOption];
      case 'eyes':
        return Gameplay.bodyOptions[Gameplay.races[raceID]][bodyOption][selectedOption];
      case 'mouth':
        return Gameplay.bodyOptions[Gameplay.races[raceID]][bodyOption][selectedOption];
    }
  }

  ///Return the race id by the name of the race, in case of errors return 0
  static int returnRaceIDbyName(raceName) {
    for (var entry in races.entries) {
      if (entry.value == raceName) {
        return entry.key;
      }
    }
    return 0;
  }

  ///This function starts the main gameplay
  void start(context) {
    Dialogs.loadingDialog(context: context);
    _engine = Engine();
    _engine.initNavigatorSocket(context, (data) {
      Navigator.pop(context);
      _engine.closeNavigatorSocket();
    });
  }

  //---
  //EVERTHING DOWN THIS IS DEPRECATED
  //---
  //System Provider
  Map _characters = {};
  int _selectedCharacter = 0;
  bool _isTalkable = false;
  List<String> _selectedTalk = [];
  String _selectedNPC = 'wizard';
  int _worldId = 0;
  List<String> _battleLog = [];
  String _location = '';

  Map get characters => _characters;
  int get selectedCharacter => _selectedCharacter;
  bool get isTalkable => _isTalkable;
  int get worldId => _worldId;
  List<String> get selectedTalk => _selectedTalk;
  String get selectedNPC => _selectedNPC;
  List<String> get battleLog => _battleLog;
  String get location => _location;

  //Players Provider
  double _playerLife = 0;
  double _playerMana = 0;
  double _playerGold = 0;
  double _playerArmor = 0;
  double _playerXP = 0;
  int _playerLevel = 1;
  double _playerStrength = 0;
  double _playerAgility = 0;
  double _playerIntelligence = 0;
  int _playerLuck = 0;
  Map _playerInventory = {};
  List _playerInventorySelected = [];
  List _playerEquips = [];
  Map _playerBuffs = {};
  List _playerDebuffs = [];
  int _playerSkillpoint = 0;
  Map _playerSkills = {};
  String _playerSelectedSkill = 'basicAttack';

  double get playerLife => _playerLife;
  double get playerMana => _playerMana;
  double get playerGold => _playerGold;
  double get playerArmor => _playerArmor;
  double get playerXP => _playerXP;
  int get playerLevel => _playerLevel;
  double get playerStrength => _playerStrength;
  double get playerAgility => _playerAgility;
  double get playerIntelligence => _playerIntelligence;
  int get playerLuck => _playerLuck;
  Map get playerInventory => _playerInventory;
  List get playerInventorySelected => _playerInventorySelected;
  List get playerEquips => _playerEquips;
  Map get playerBuffs => _playerBuffs;
  int get playerSkillpoint => _playerSkillpoint;
  Map get playerSkills => _playerSkills;
  String get playerSelectedSkill => _playerSelectedSkill;
  List get playerDebuffs => _playerDebuffs;

  //Enemy Provider
  Map _enemies = {};
  bool _alreadyInBattle = false;
  List _enemiesChasing = [];

  Map _usersInWorld = {};
  Map _enemiesInWorld = {};

  Map get enemies => _enemies;
  bool get alreadyInBattle => _alreadyInBattle;
  List get enemiesChasing => _enemiesChasing;

  Map get usersInWorld => _usersInWorld;
  Map get enemiesInWorld => _enemiesInWorld;

  //------
  //System
  //------

  //Add New Enemy into List
  int addEnemiesChasing(value) {
    _enemiesChasing.add(value);
    return _enemiesChasing.length - 1;
  }

  //Remove Enemy by Index
  void removeSpecificEnemiesChasing(value) {
    try {
      //Remove Value
      _enemiesChasing.removeAt(value);
    } catch (e) {
      _enemiesChasing = [];
    }
  }

  //Update Enemy ID by Index
  void updateSpecificEnemiesChasing(valueIndex, valueID) {
    _enemiesChasing[valueIndex] = valueID;
  }

  //Find Enemy by ID
  int findSpecificEnemiesChasing(value) {
    //Sweep List
    for (int i = 0; i < _enemiesChasing.length; i++) {
      if (_enemiesChasing[i] == value) {
        return i;
      }
    }
    return -1;
  }

  //Remove All Elements in Enemies Chasing
  void cleanEnemiesChasing() {
    _enemiesChasing = [];
  }

  //Change Players Profile Characters
  void changeCharacters(Map value) {
    _characters = value;
  }

  //Change the Selected Character
  void changeSelectedCharacter(int value) {
    _selectedCharacter = value;
  }

  //Change already in battle
  void changeAlreadyInBattle(bool value) {
    _alreadyInBattle = value;
  }

  //Change location
  void changeLocation(value) {
    _location = value;
  }

  //Users In World Handle
  void usersHandle(handle, [data]) {
    switch (handle) {
      case 'add':
        _usersInWorld[data['id']] = data;
        break;
      case 'replace':
        _usersInWorld = data;
        break;
      case 'clean':
        _usersInWorld = {};
        break;
    }
  }

  //Enemy In World Handle
  void enemyHandle(handle, [data]) {
    switch (handle) {
      case 'add':
        _enemiesInWorld[data['id']] = data;
        break;
      case 'replace':
        _enemiesInWorld = data;
        break;
      case 'clean':
        _enemiesInWorld = {};
        break;
    }
  }

  //Change world id
  void changeWorldId(value) {
    _worldId = value;
  }

  //Change the talk text
  void changeIsTalkable(value, [npc]) {
    if (!value) {
      _isTalkable = value;
      notifyListeners();
      return;
    }
    _isTalkable = value;
    List<String> talk = [];
    try {
      npc['talk'].forEach((npc) => talk.add(npc));
    } catch (error) {
      talk = [''];
    }
    _selectedTalk = talk;
    _selectedNPC = npc['name'];
    notifyListeners();
  }

  //Show Text Talk Dialog
  static void showTalkText(context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    int index = 0;
    showModalBottomSheet<void>(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => GestureDetector(
              onTap: () {
                //Change index
                if (index < gameplay.selectedTalk.length - 1) {
                  //Update
                  setState(() {
                    index++;
                  });
                }
              },
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height * 0.25,
                child: FittedBox(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              child: Stack(
                            children: [
                              //Profile Image
                              Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: SizedBox(
                                  width: 28,
                                  height: 38,
                                  child: Image.asset(
                                    'assets/images/interface/profileimage.png',
                                  ),
                                ),
                              ),
                              //Npc Image
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 17.5,
                                    height: 26,
                                    child: Image.asset(
                                      'assets/images/npc/${gameplay.selectedNPC}.png',
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ],
                          )),
                          //Board
                          Stack(
                            children: [
                              //Board Image
                              SizedBox(
                                width: 70,
                                height: screenSize.height * 0.05,
                                child: Image.asset(
                                  'assets/images/interface/boardtext.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              //Board Text
                              Container(
                                padding: const EdgeInsets.only(top: 5, left: 6),
                                width: 65,
                                height: 33,
                                child: SingleChildScrollView(
                                  child: Text(
                                    Language.Translate(gameplay.selectedTalk[index], options.language) ?? 'Language Error',
                                    style: TextStyle(fontSize: 5, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              gameplay.selectedTalk.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 35.0, left: 58),
                                      child: Text(
                                        '${index + 1}/${gameplay.selectedTalk.length}',
                                        style: TextStyle(fontSize: 5, color: Theme.of(context).primaryColor),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //------
  //Battle
  //------

  //Change Selected Skill
  void changePlayerSelectedSkill(value) {
    _playerSelectedSkill = value;
  }

  //Add a line to battle log
  void addBattleLog(value, context) {
    final options = Provider.of<Options>(context, listen: false);
    String result = '';
    for (int i = 1; i <= value.length; i++) {
      if (!value['log$i'].toString().contains('_')) {
        result = '$result${value['log$i'].toString()}';
      } else {
        result = '$result${Language.Translate(value['log$i'], options.language) ?? 'Language Error'}';
      }
    }
    _battleLog.add(result);
    notifyListeners();
  }

  //Reset Battle Log
  void resetBattleLog() {
    _battleLog = [];
    notifyListeners();
  }

  //Change Player Stats or Enemy Stats
  void changeStats({required value, required String stats, int enemyNumber = -1}) {
    //Player Stats
    if (stats == 'life') {
      _playerLife = value;
      notifyListeners();
      return;
    } else if (stats == 'mana') {
      _playerMana = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'gold') {
      _playerGold = value;
      notifyListeners();
      return;
    } else if (stats == 'armor') {
      _playerArmor = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'level') {
      _playerLevel = value;
      notifyListeners();
      return;
    } else if (stats == 'xp') {
      _playerXP = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'strength') {
      _playerStrength = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'agility') {
      _playerAgility = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'intelligence') {
      _playerIntelligence = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'luck') {
      _playerLuck = value;
      notifyListeners();
      return;
    } else if (stats == 'inventory') {
      try {
        _playerInventory = value;
      } catch (_) {
        _playerInventory = jsonDecode(value);
      }
      notifyListeners();
      return;
    } else if (stats == 'equips') {
      try {
        _playerEquips = value;
      } catch (_) {
        _playerEquips = jsonDecode(value);
      }
      notifyListeners();
      return;
    } else if (stats == 'buffs') {
      try {
        _playerBuffs = jsonDecode(value);
      } catch (error) {
        _playerBuffs = value;
      }
      notifyListeners();
      return;
    } else if (stats == 'skillpoint') {
      _playerSkillpoint = value;
      notifyListeners();
      return;
    } else if (stats == 'skills') {
      try {
        _playerSkills = jsonDecode(value);
      } catch (error) {
        _playerSkills = value;
      }
      notifyListeners();
    } else if (stats == 'debuffs') {
      _playerDebuffs = value;
      notifyListeners();
    }
    //Check enemy number
    if (enemyNumber == -1) {
      return;
    } else {
      //Check if already exist
      if (_enemies['enemy$enemyNumber'] == null) {
        //Create
        _enemies['enemy$enemyNumber'] = {};
      }
    }
    //Enemy Stats
    if (stats == 'elife') {
      if (value == "dead") {
        _enemies['enemy$enemyNumber']['life'] = 0.0;
      } else {
        _enemies['enemy$enemyNumber']['life'] = double.parse(value.toStringAsFixed(2));
        notifyListeners();
      }
      return;
    } else if (stats == 'emana') {
      _enemies['enemy$enemyNumber']['mana'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'ename') {
      _enemies['enemy$enemyNumber']['name'] = value.toString();
      notifyListeners();
      return;
    } else if (stats == 'earmor') {
      _enemies['enemy$enemyNumber']['armor'] = value;
      notifyListeners();
      return;
    } else if (stats == 'elevel') {
      _enemies['enemy$enemyNumber']['level'] = int.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'edamage') {
      _enemies['enemy$enemyNumber']['damage'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'exp') {
      _enemies['enemy$enemyNumber']['xp'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'ebuffs') {
      _enemies['enemy$enemyNumber']['buffs'] = value;
      notifyListeners();
      return;
    } else if (stats == 'eskills') {
      _enemies['enemy$enemyNumber']['skills'] = value;
      notifyListeners();
      return;
    } else if (stats == 'estrength') {
      _enemies['enemy$enemyNumber']['strength'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'eagility') {
      _enemies['enemy$enemyNumber']['agility'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'eintelligence') {
      _enemies['enemy$enemyNumber']['intelligence'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'edebuffs') {
      _enemies['enemy$enemyNumber']['debuffs'] = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'ereset') {
      _enemies = {};
      notifyListeners();
    } else if (stats == 'eid') {
      _enemies['enemy$enemyNumber']['id'] = int.parse(value.toString());
      notifyListeners();
    }
  }

  //------
  //Inventory
  //------

//Add Specific Item in inventory
  void addSpecificItemInventory(item) {
    //Test if already have in inventory
    try {
      if (playerInventory[item['name']]['quantity'] >= 1) {
        //Add 1 quantity
        playerInventory[item['name']]['quantity'] = playerInventory[item['name']]['quantity'] + 1;
      }
      //Add to the inventory if doesnt exist
    } catch (error) {
      _playerInventory[item['name']] = item;
    }
  }

//Reset Selected Inventory
  void resetPlayerInventorySelected() {
    _playerInventorySelected = [];
  }

//Change Player Inventory
  void changePlayerInventory(Map value) {
    _playerInventory = value;
  }

//Add Selected playerInventorySelected
  void addPlayerInventorySelected(value) {
    _playerInventorySelected.add(value);
  }

//Add Items to invetory
  Map addInventoryItem(List items) {
    bool jumpClear = false;
    for (int i = 0; i <= items.length - 1; i++) {
      try {
        //If inventory is clear
        if (_playerInventory.isEmpty && !jumpClear) {
          _playerInventory[items[i]['name']] = items[i];
          i++;
          jumpClear = true;
        }
        //Doesnt Exist in inventory
        if (_playerInventory[items[i]['name']] == null) {
          _playerInventory[items[i]['name']] = items[i];
          //Exist in inventory
        } else {
          final calculation = _playerInventory[items[i]['name']]['quantity'] + items[i]['quantity'];
          _playerInventory[items[i]['name']]['quantity'] = calculation;
        }
      } catch (_) {}
    }
    return _playerInventory;
  }
}
