import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  bool _isLoading = false;
  Map _baseAtributes = {};
  Map _levelCaps = {};
  Map _skillsId = {};
  Map _itemsId = {};

  bool get isLoading => _isLoading;
  Map get baseAtributes => _baseAtributes;
  Map get levelCaps => _levelCaps;
  Map get skillsId => _skillsId;
  Map get itemsId => _itemsId;

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
      return itemsId[itemName]['image'];
    }
    return itemsId[itemName]['image'];
  }

  //Returns the tier
  String itemTier(itemName, {addPlus = false}) {
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
  String tierCheck(itemName) {
    if (itemName.contains('%')) {
      itemName = itemName.substring(0, itemName.length - 3);
      return itemName;
    }
    return itemName;
  }
}
