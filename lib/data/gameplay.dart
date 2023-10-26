import 'dart:convert';

import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Gameplay with ChangeNotifier {
  //All Classes
  static Map classes = {
    0: 'assets/characters/archer.png',
    1: 'assets/characters/assassin.png',
    2: 'assets/characters/bard.png',
    3: 'assets/characters/beastmaster.png',
    4: 'assets/characters/berserk.png',
    5: 'assets/characters/druid.png',
    6: 'assets/characters/mage.png',
    7: 'assets/characters/paladin.png',
    8: 'assets/characters/priest.png',
    9: 'assets/characters/trickmagician.png',
    10: 'assets/characters/weaponsmith.png',
    11: 'assets/characters/witch.png',
  };

  //All Races
  static Map races = {
    0: 'human',
    1: 'nature',
    2: 'dytol',
    3: 'aghars',
    4: 'dark',
    5: 'undead',
  };

  //All Body Options
  static Map bodyOptions = {
    'human': {
      'male': {
        'idle': 'assets/images/players/human/male_idle.png',
        'running0': 'assets/images/players/human/male_running0.png',
        'running1': 'assets/images/players/human/male_running1.png',
        'running2': 'assets/images/players/human/male_running2.png',
        'running3': 'assets/images/players/human/male_running3.png',
      },
      'female': {},
      'hair': {
        0: 'assets/images/players/human/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/human/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/human/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/human/skin0.png',
      },
    },
    'nature': {
      'hair': {
        0: 'assets/images/players/nature/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/nature/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/nature/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/nature/skin0.png',
      },
    },
    'dytol': {
      'hair': {
        0: 'assets/images/players/dytol/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/dytol/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/dytol/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/dytol/skin0.png',
      },
    },
    'aghars': {
      'hair': {
        0: 'assets/images/players/aghars/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/aghars/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/aghars/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/aghars/skin0.png',
      },
    },
    'dark': {
      'hair': {
        0: 'assets/images/players/dark/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/dark/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/dark/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/dark/skin0.png',
      },
    },
    'undead': {
      'hair': {
        0: 'assets/images/players/undead/hair0.png',
      },
      'eyes': {
        0: 'assets/images/players/undead/eyes0.png',
      },
      'mouth': {
        0: 'assets/images/players/undead/mouth0.png',
      },
      'skin': {
        0: 'assets/images/players/undead/skin0.png',
      },
    },
  };

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
