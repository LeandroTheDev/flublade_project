import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  bool _isLoading = false;
  Map _baseAtributes = {};
  Map _levelCaps = {};
  Map _skillsId = {};
  Map _itemsId = {};
  final Map _equipmentSettings = {
    "none": {
      "size": Vector2.all(0.0),
      "position": Vector2.all(0.0),
      "textureSize": Vector2.all(0.0),
      "idleAmount": 1,
      "idleStep": 0.1,
      "runAmount": 1,
      "runStep": 0.1,
    },
    "leather_helmet": {
      "size": Vector2.all(32.0),
      "position": Vector2.all(16.0),
      "textureSize": Vector2.all(0.0),
      "idleAmount": 1,
      "idleStep": 0.1,
      "runAmount": 1,
      "runStep": 0.1,
    }
  };

  bool get isLoading => _isLoading;
  Map get baseAtributes => _baseAtributes;
  Map get levelCaps => _levelCaps;
  Map get skillsId => _skillsId;
  Map get itemsId => _itemsId;
  Map get equipmentSettings => _equipmentSettings;

  void changeIsLoading({value}) {
    if (value == null) {
      _isLoading = !_isLoading;
      notifyListeners();
    } else if (value) {
      _isLoading = true;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Change Items Id
  void changeItemsId(Map value) {
    _itemsId = value;
  }

  //Translate equip index
  List translateEquipsIndex(equipIndex) {
    //Documentation
    //0 Helmet
    //1 ??
    //2 ??
    //3 Amulet
    //4 Left Gloves
    //5 Right Gloves
    //6 Chest Plate
    //7 Leggings
    //8 Boots
    //9 Left Weapon
    //10 Right Weapon
    return [0];
  }

  //Change Base Atributes
  void changeBaseAtributes(Map value) {
    _baseAtributes = value;
  }

  //Change Level Caps
  void changeLevelCaps(Map value) {
    _levelCaps = value;
  }

  //Change Skills Id
  void changeSkillsId(Map value) {
    _skillsId = value;
  }

  //Returns the Loot/Item Image
  String lootImage(itemName) {
    if (itemName.contains('%')) {
      itemName = itemName.substring(0, itemName.length - 3);
      return _itemsId[itemName]['image'];
    }
    return _itemsId[itemName]['image'];
  }

  //Returns the tier
  static String itemTier(itemName, {addPlus = false}) {
    if (itemName.contains('%')) {
      final tier = int.parse(itemName.substring(itemName.length - 2));
      if (addPlus) {
        return '+${tier.toString()}';
      }
      return tier.toString();
    }
    return '';
  }

  //Returns the item name without Tier
  static String tierCheck(itemName) {
    if (itemName.contains('%')) {
      itemName = itemName.substring(0, itemName.length - 3);
      return itemName;
    }
    return itemName;
  }
}
