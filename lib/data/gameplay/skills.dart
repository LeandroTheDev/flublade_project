import 'dart:convert';

import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassivesSkills {
  static const passivesId = {
    'healthTurbo': {
      'image': 'assets/skills/passives',
      'name': 'healthTurbo',
    }
  };
  static passives(context, passiveName) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);

    //Health Turbo Function
    healthTurbo() {}
    //Damage Turbo Function
    damageTurbo() {}
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

      return double.parse(damageCalculator().toStringAsFixed(1));
    }
    //Player Max Life Calculation to General
    if (playerMaxLifeCalculationInGeneral) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      final character = jsonDecode(gameplay.characters);
      //Berserk Class
      if (character['character${gameplay.selectedCharacter}']['class'] ==
          'berserk') {
        for (int i = 1; i > gameplay.playerStrength; i++) {}
      }
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
      final character = jsonDecode(gameplay.characters);
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

      //Berserk Class
      if (character['character${gameplay.selectedCharacter}']['class'] ==
          'berserk') {
        List result = [0.0, ''];
        double damage = double.parse(damageCalculator().toStringAsFixed(1));
        double life = gameplay.playerLife;
        double armorPorcentage = armorPorcentageCalculator(gameplay.enemyArmor);
        double elife = gameplay.enemyLife;
        double earmorPorcentage =
            armorPorcentageCalculator(gameplay.enemyArmor);
        double edamage = gameplay.enemyDamage;

        //Player Turn
        if (values == 'playerTurn') {
          elife = elife - (damage * ((100 - earmorPorcentage) / 100));
          result[0] = (damage * ((100 - earmorPorcentage) / 100));
          await Future.delayed(const Duration(milliseconds: 700));
          gameplay.changeStats(
              value: double.parse(elife.toStringAsFixed(1)), stats: 'elife');
          //Check if enemy is dead
          if (elife <= 0) {
            gameplay.addBattleLog(
                Language.Translate('battle_log_enemyDead', options.language) ??
                    'You killed');
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
          await Future.delayed(const Duration(milliseconds: 700));
          gameplay.changeStats(
              value: double.parse(life.toStringAsFixed(1)), stats: 'life');
          //Check if player is dead
          if (life <= 0) {
            result[1] = 'dead';
          } else {
            result[1] = 'notdead';
          }
          return result;
        }

        return;
      }
      //Archer Class
      if (character['character${gameplay.selectedCharacter}']['class'] ==
          'archer') {
        double damage = double.parse(damageCalculator().toStringAsFixed(1));
        double elife = gameplay.enemyLife;
        elife = elife - damage;
        gameplay.changeStats(
            value: double.parse(elife.toStringAsFixed(1)), stats: 'elife');
      }
    }
  }
}
