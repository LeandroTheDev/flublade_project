import 'dart:convert';

import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/global.dart';
import 'package:provider/provider.dart';

class PassivesSkills {
  //Return Calculation
  static passives(context, passiveName, methodTranlation) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final settings = Provider.of<Settings>(context, listen: false);
    //Health Turbo Function
    healthTurbo() {
      //Variables Creation
      final maxLife = ClassAtributes.classTranslation(
          context: context, playerMaxLifeCalculationInGeneral: true);
      final porcentage = double.parse(
          (((maxLife - gameplay.playerLife) / maxLife) * 100)
              .toStringAsFixed(2));
      double totalLifeRecovery = 0.0;

      //Porcentage Calculation
      for (double i = 100.0 - porcentage; i <= 100; i += 2) {
        totalLifeRecovery += maxLife * 0.005;
      }

      //Returning
      totalLifeRecovery = double.parse(totalLifeRecovery.toStringAsFixed(2));
      return [
        'addLife',
        totalLifeRecovery,
        settings.skillsId['healthTurbo']!['isLate'],
      ];
    }

    //Damage Turbo Function
    damageTurbo() {
      //Variables Creation
      final baseDamage = ClassAtributes.classTranslation(
          context: context, playerDamageCalculationInStats: true);
      final maxLife = ClassAtributes.classTranslation(
          context: context, playerMaxLifeCalculationInGeneral: true);
      final porcentage = double.parse(
          (((maxLife - gameplay.playerLife) / maxLife) * 100)
              .toStringAsFixed(2));
      double totalDamage = 0.0;

      //Porcentage Calculation
      for (double i = 100.0 - porcentage; i <= 100; i += 5) {
        totalDamage += baseDamage * 0.03;
      }

      //Returning
      totalDamage = double.parse(totalDamage.toStringAsFixed(2));
      return [
        'addDamage',
        totalDamage,
        settings.skillsId['damageTurbo']!['isLate']
      ];
    }

    //Passive Translation
    switch (passiveName) {
      case 'healthTurbo':
        //Health Turbo
        return healthTurbo();
      case 'damageTurbo':
        //Damage Turbo
        return damageTurbo();
    }
  }
}

class ClassAtributes {
  //Class Calculations
  static classTranslation({
    context,
    values,
    bool playerDamageCalculationInEnemy = false,
    bool playerDamageCalculationInStats = false,
    bool playerMaxLifeCalculationInGeneral = false,
    bool playterMaxLifeCalculationCharacterCreation = false,
  }) {
    //Player Damage Calculation to Stats
    if (playerDamageCalculationInStats) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      //Damage Calculator
      double damageCalculator() {
        //No weapons equipped
        if (gameplay.playerEquips[9] == 'none' &&
            gameplay.playerEquips[10] == 'none') {
          if (gameplay.playerStrength >= 12) {
            return 1 * (gameplay.playerStrength * 0.1);
          }
          return 1;
          //Only Left weapon equipped
        } else if (gameplay.playerEquips[9] != 'none' &&
            gameplay.playerEquips[10] == 'none') {
          if (gameplay.playerStrength >= 12) {
            return Items.list[gameplay.playerEquips[9]]['damage'] *
                (gameplay.playerStrength * 0.1);
          }
          return Items.list[gameplay.playerEquips[9]]['damage'];
          //Only Right weapon equipped
        } else if (gameplay.playerEquips[9] == 'none' &&
            gameplay.playerEquips[10] != 'none') {
          if (gameplay.playerStrength >= 12) {
            return Items.list[gameplay.playerEquips[10]]['damage'] *
                (gameplay.playerStrength * 0.1);
          }
          return Items.list[gameplay.playerEquips[10]]['damage'];
          //Left & Right weapon equipped
        } else if (gameplay.playerEquips[9] != 'none' &&
            gameplay.playerEquips[10] != 'none') {
          if (gameplay.playerStrength >= 12) {
            return (Items.list[gameplay.playerEquips[9]]['damage'] +
                    Items.list[gameplay.playerEquips[10]]['damage']) *
                (gameplay.playerStrength * 0.1);
          }
          return (Items.list[gameplay.playerEquips[9]]['damage'] +
              Items.list[gameplay.playerEquips[10]]['damage']);
        }
        return 0.0;
      }

      return double.parse(damageCalculator().toStringAsFixed(2));
    }
    //Player Class Max Life Calculation
    if (playerMaxLifeCalculationInGeneral) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      final settings = Provider.of<Settings>(context, listen: false);
      final character = jsonDecode(gameplay.characters);
      //Pickup base Max life
      double maxLife = double.parse(settings.baseAtributes[
              character['character${gameplay.selectedCharacter}']
                  ['class']]!['life']
          .toString());
      //Calculation by strength
      for (int i = 0; i < gameplay.playerStrength; i++) {
        maxLife = maxLife + (maxLife * 0.05);
      }
      //Rounded Life
      maxLife = double.parse(maxLife.toStringAsFixed(2));
      return maxLife;
    }
    //Player Class Max Life Calculation Creation
    if (playterMaxLifeCalculationCharacterCreation) {
      final settings = Provider.of<Settings>(context, listen: false);
      //Pickup base Max life
      double maxLife =
          double.parse(settings.baseAtributes[values]!['life'].toString());
      //Calculation by strength
      for (int i = 0;
          i < int.parse(settings.baseAtributes[values]!['strength'].toString());
          i++) {
        maxLife = maxLife + (maxLife * 0.05);
      }
      //Rounded Life
      maxLife = double.parse(maxLife.toStringAsFixed(2));
      return maxLife;
    }
  }

  static Future<dynamic> battleFunctions({
    context,
    values,
    bool playerDamageCalculationInEnemy = false,
  }) async {
    //Player Damage Calculation to Enemy
    if (playerDamageCalculationInEnemy) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      final options = Provider.of<Options>(context, listen: false);
      //Returns the player total damage
      double damageCalculator() {
        //No weapons equipped
        if (gameplay.playerEquips[9] == 'none' &&
            gameplay.playerEquips[10] == 'none') {
          if (gameplay.playerStrength >= 12) {
            return 1 * (gameplay.playerStrength * 0.1);
          }
          return 1;
          //Only Left weapon equipped
        } else if (gameplay.playerEquips[9] != 'none' &&
            gameplay.playerEquips[10] == 'none') {
          if (gameplay.playerStrength >= 12) {
            return Items.list[gameplay.playerEquips[9]]['damage'] *
                (gameplay.playerStrength * 0.1);
          }
          return Items.list[gameplay.playerEquips[9]]['damage'];
          //Only Right weapon equipped
        } else if (gameplay.playerEquips[9] == 'none' &&
            gameplay.playerEquips[10] != 'none') {
          if (gameplay.playerStrength >= 12) {
            return Items.list[gameplay.playerEquips[10]]['damage'] *
                (gameplay.playerStrength * 0.1);
          }
          return Items.list[gameplay.playerEquips[10]]['damage'];
          //Left & Right weapon equipped
        } else if (gameplay.playerEquips[9] != 'none' &&
            gameplay.playerEquips[10] != 'none') {
          if (gameplay.playerStrength >= 12) {
            return (Items.list[gameplay.playerEquips[9]]['damage'] +
                    Items.list[gameplay.playerEquips[10]]['damage']) *
                (gameplay.playerStrength * 0.1);
          }
          return (Items.list[gameplay.playerEquips[9]]['damage'] +
              Items.list[gameplay.playerEquips[10]]['damage']);
        }
        return 0.0;
      }

      //Returns Armor Porcentage Calculator
      double armorPorcentageCalculator(armor) {
        //Limit Armor
        if (armor >= 680) {
          return 90.0;
        }
        if (armor <= 20) {
          armor = armor / 2;
          return double.parse(armor.toStringAsFixed(1));
        } else if (armor <= 50 && armor >= 21) {
          const basePorcentage = 10.0;
          armor = (armor / 3) + basePorcentage;
          return double.parse(armor.toStringAsFixed(1));
        } else if (armor <= 150 && armor >= 51) {
          const basePorcentage = 26.6;
          armor = (armor / 5) + basePorcentage;
          return double.parse(armor.toStringAsFixed(1));
        } else {
          const basePorcentage = 56.6;
          armor = (armor / 20) + basePorcentage;
          return double.parse(armor.toStringAsFixed(1));
        }
      }

      //Variables Creation
      List result = [0.0, ''];
      double damage = double.parse(damageCalculator().toStringAsFixed(2));
      double life = gameplay.playerLife;
      double armorPorcentage = armorPorcentageCalculator(gameplay.enemyArmor);
      double elife = gameplay.enemyLife;
      double earmorPorcentage = armorPorcentageCalculator(gameplay.enemyArmor);
      double edamage = gameplay.enemyDamage;

      //Buffs Searchs
      List buffs = [];
      gameplay.playerBuffs.forEach((value, index) => buffs.add(value));
      List buffsNumbers = [];
      for (int i = 0; i <= buffs.length - 1; i++) {
        buffsNumbers.add(PassivesSkills.passives(context, buffs[i], false));
      }
      //Player Turn
      if (values == 'playerTurn') {
        //Early Buffs Calculation
        for (int i = 0; i <= buffsNumbers.length - 1; i++) {
          try {
            //Add Damage activation
            if (buffsNumbers[i][0] == 'addDamage' &&
                buffsNumbers[i][2] == false) {
              damage += buffsNumbers[i][1];
            }
            // ignore: empty_catches
          } catch (error) {}
        }

        //Damage Calculation
        elife = elife - (damage * ((100 - earmorPorcentage) / 100));
        result[0] = (damage * ((100 - earmorPorcentage) / 100));

        //Damage on Provider
        await Future.delayed(Duration(milliseconds: options.textSpeed));
        gameplay.changeStats(
            value: double.parse(elife.toStringAsFixed(2)), stats: 'elife');

        //Check if enemy is dead
        if (elife <= 0) {
          result[1] = 'edead';
        } else {
          result[1] = 'notedead';
        }
        return result;
      }

      //Enemy Turn
      if (values == 'enemyTurn') {
        life = life - (edamage * ((100 - armorPorcentage) / 100));
        result[0] = (edamage * ((100 - armorPorcentage) / 100));
        await Future.delayed(Duration(milliseconds: options.textSpeed));
        gameplay.changeStats(
            value: double.parse(life.toStringAsFixed(2)), stats: 'life');
        //Check if player is dead
        if (life <= 0) {
          result[1] = 'dead';
        } else {
          result[1] = 'notdead';
        }
        return result;
      }

      //Late Buffs
      if (values == 'lateBuffs') {
        return buffsNumbers;
      }
      return;
    }
  }
}
