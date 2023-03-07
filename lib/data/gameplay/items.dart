import 'package:flutter/material.dart';

class Items {
  static const Map lootId = {
    //Common
    0: 'gold',
    1: 'thread',
    2: 'cloth',
    //Rare Items
    100: 'woodsword',
    101: 'woodsword01',
    102: 'woodsword02',
    //Ultra Rare Items
    200: 'woodsword03',
    201: 'woodsword04',
    202: 'woodsword05',
  };

  static const Map list = {
    //Misc
    'gold': {
      'image': 'assets/items/gold.png',
      'price': null,
      'name': 'gold',
      'equip': 'none',
      'rarity': 0,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'misc',
    },
    'thread': {
      'image': 'assets/items/thread.png',
      'price': 1,
      'name': 'thread',
      'equip': 'none',
      'rarity': 0,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'misc',
    },
    'cloth': {
      'image': 'assets/items/cloth.png',
      'price': 1,
      'name': 'cloth',
      'equip': 'none',
      'rarity': 0,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'misc',
    },
    //Weapons
    'woodsword': {
      'image': 'assets/items/wooden_sword.png',
      'price': 5,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 0,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '3',
    },
    'woodsword01': {
      'image': 'assets/items/wooden_sword.png',
      'price': 10,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 1,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '6',
    },
    'woodsword02': {
      'image': 'assets/items/wooden_sword.png',
      'price': 15,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 1,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '9',
    },
    'woodsword03': {
      'image': 'assets/items/wooden_sword.png',
      'price': 20,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 2,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '12',
    },
    'woodsword04': {
      'image': 'assets/items/wooden_sword.png',
      'price': 25,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 2,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '16',
    },
    'woodsword05': {
      'image': 'assets/items/wooden_sword.png',
      'price': 30,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 2,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '20',
    },
    'woodsword06': {
      'image': 'assets/items/wooden_sword.png',
      'price': 35,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 3,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '24',
    },
    'woodsword07': {
      'image': 'assets/items/wooden_sword.png',
      'price': 40,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 3,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '28',
    },
    'woodsword08': {
      'image': 'assets/items/wooden_sword.png',
      'price': 50,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 3,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '35',
    },
    'woodsword09': {
      'image': 'assets/items/wooden_sword.png',
      'price': 65,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 3,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '45',
    },
    'woodsword10': {
      'image': 'assets/items/wooden_sword.png',
      'price': 100,
      'name': 'woodsword',
      'equip': '1weapon',
      'rarity': 4,
      'consumable': false,
      'quest': false,
      'forge': false,
      'category': 'weapon',
      'damage': '60',
    },
    //Armors
  };

  static Color returnRarity(itemName) {
    final rarity = list[itemName]['rarity'];
    switch (rarity) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
    }
    return Colors.grey;
  }

  static String returnTier(String itemName) {
    if(itemName.endsWith('01')) {
      return '1';
    }
    if(itemName.endsWith('02')) {
      return '2';
    }
    if(itemName.endsWith('03')) {
      return '3';
    }
    if(itemName.endsWith('04')) {
      return '4';
    }
    if(itemName.endsWith('05')) {
      return '5';
    }
    if(itemName.endsWith('06')) {
      return '6';
    }
    if(itemName.endsWith('07')) {
      return '7';
    }
    if(itemName.endsWith('08')) {
      return '8';
    }
    if(itemName.endsWith('09')) {
      return '9';
    }
    if(itemName.endsWith('10')) {
      return '10';
    }
    return '0';
  }
}
