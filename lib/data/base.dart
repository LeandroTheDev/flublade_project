class Base {
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
            'running0': 'assets/images/players/human/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/human/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/human/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/human/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/human/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/human/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/human/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/human/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/human/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/human/body/male_body_idle.png',
          'running0': 'assets/images/players/human/body/male_body_running0.png',
          'running1': 'assets/images/players/human/body/male_body_running1.png',
          'running2': 'assets/images/players/human/body/male_body_running2.png',
          'running3': 'assets/images/players/human/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/human/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/human/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/human/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/human/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/human/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/human/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/human/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/human/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/human/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/human/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/human/body/female_body_idle.png',
          'running0': 'assets/images/players/human/body/female_body_running0.png',
          'running1': 'assets/images/players/human/body/female_body_running1.png',
          'running2': 'assets/images/players/human/body/female_body_running2.png',
          'running3': 'assets/images/players/human/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/human/hair/0/hair.png',
        1: 'assets/images/players/human/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/human/eyes/0/eyes.png',
        1: 'assets/images/players/human/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/human/mouth/0/mouth.png',
        1: 'assets/images/players/human/mouth/1/mouth.png',
      },
    },
    'nature': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/nature/skin/0/male_skin_idle.png',
            'running0': 'assets/images/players/nature/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/nature/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/nature/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/nature/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/nature/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/nature/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/nature/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/nature/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/nature/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/nature/body/male_body_idle.png',
          'running0': 'assets/images/players/nature/body/male_body_running0.png',
          'running1': 'assets/images/players/nature/body/male_body_running1.png',
          'running2': 'assets/images/players/nature/body/male_body_running2.png',
          'running3': 'assets/images/players/nature/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/nature/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/nature/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/nature/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/nature/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/nature/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/nature/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/nature/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/nature/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/nature/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/nature/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/nature/body/female_body_idle.png',
          'running0': 'assets/images/players/nature/body/female_body_running0.png',
          'running1': 'assets/images/players/nature/body/female_body_running1.png',
          'running2': 'assets/images/players/nature/body/female_body_running2.png',
          'running3': 'assets/images/players/nature/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/nature/hair/0/hair.png',
        1: 'assets/images/players/nature/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/nature/eyes/0/eyes.png',
        1: 'assets/images/players/nature/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/nature/mouth/0/mouth.png',
        1: 'assets/images/players/nature/mouth/1/mouth.png',
      },
    },
    'dytol': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dytol/skin/0/male_skin_idle.png',
            'running0': 'assets/images/players/dytol/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/dytol/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/dytol/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/dytol/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/dytol/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/dytol/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/dytol/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/dytol/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/dytol/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dytol/body/male_body_idle.png',
          'running0': 'assets/images/players/dytol/body/male_body_running0.png',
          'running1': 'assets/images/players/dytol/body/male_body_running1.png',
          'running2': 'assets/images/players/dytol/body/male_body_running2.png',
          'running3': 'assets/images/players/dytol/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dytol/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/dytol/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/dytol/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/dytol/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/dytol/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/dytol/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/dytol/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/dytol/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/dytol/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/dytol/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dytol/body/female_body_idle.png',
          'running0': 'assets/images/players/dytol/body/female_body_running0.png',
          'running1': 'assets/images/players/dytol/body/female_body_running1.png',
          'running2': 'assets/images/players/dytol/body/female_body_running2.png',
          'running3': 'assets/images/players/dytol/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/dytol/hair/0/hair.png',
        1: 'assets/images/players/dytol/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/dytol/eyes/0/eyes.png',
        1: 'assets/images/players/dytol/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/dytol/mouth/0/mouth.png',
        1: 'assets/images/players/dytol/mouth/1/mouth.png',
      },
    },
    'aghars': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/aghars/skin/0/male_skin_idle.png',
            'running0': 'assets/images/players/aghars/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/aghars/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/aghars/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/aghars/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/aghars/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/aghars/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/aghars/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/aghars/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/aghars/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/aghars/body/male_body_idle.png',
          'running0': 'assets/images/players/aghars/body/male_body_running0.png',
          'running1': 'assets/images/players/aghars/body/male_body_running1.png',
          'running2': 'assets/images/players/aghars/body/male_body_running2.png',
          'running3': 'assets/images/players/aghars/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/aghars/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/aghars/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/aghars/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/aghars/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/aghars/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/aghars/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/aghars/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/aghars/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/aghars/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/aghars/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/aghars/body/female_body_idle.png',
          'running0': 'assets/images/players/aghars/body/female_body_running0.png',
          'running1': 'assets/images/players/aghars/body/female_body_running1.png',
          'running2': 'assets/images/players/aghars/body/female_body_running2.png',
          'running3': 'assets/images/players/aghars/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/aghars/hair/0/hair.png',
        1: 'assets/images/players/aghars/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/aghars/eyes/0/eyes.png',
        1: 'assets/images/players/aghars/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/aghars/mouth/0/mouth.png',
        1: 'assets/images/players/aghars/mouth/1/mouth.png',
      },
    },
    'dark': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dark/skin/0/male_skin_idle.png',
            'running0': 'assets/images/players/dark/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/dark/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/dark/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/dark/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/dark/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/dark/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/dark/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/dark/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/dark/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dark/body/male_body_idle.png',
          'running0': 'assets/images/players/dark/body/male_body_running0.png',
          'running1': 'assets/images/players/dark/body/male_body_running1.png',
          'running2': 'assets/images/players/dark/body/male_body_running2.png',
          'running3': 'assets/images/players/dark/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/dark/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/dark/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/dark/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/dark/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/dark/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/dark/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/dark/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/dark/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/dark/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/dark/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/dark/body/female_body_idle.png',
          'running0': 'assets/images/players/dark/body/female_body_running0.png',
          'running1': 'assets/images/players/dark/body/female_body_running1.png',
          'running2': 'assets/images/players/dark/body/female_body_running2.png',
          'running3': 'assets/images/players/dark/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/human/hair/0/hair.png',
        1: 'assets/images/players/human/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/human/eyes/0/eyes.png',
        1: 'assets/images/players/human/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/human/mouth/0/mouth.png',
        1: 'assets/images/players/human/mouth/1/mouth.png',
      },
    },
    'undead': {
      'male': {
        'skin': {
          0: {
            'idle': 'assets/images/players/undead/skin/0/male_skin_idle.png',
            'running0': 'assets/images/players/undead/skin/0/male_body_running0.png',
            'running1': 'assets/images/players/undead/skin/0/male_body_running1.png',
            'running2': 'assets/images/players/undead/skin/0/male_body_running2.png',
            'running3': 'assets/images/players/undead/skin/0/male_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/undead/skin/1/male_skin_idle.png',
            'running0': 'assets/images/players/undead/skin/1/male_body_running0.png',
            'running1': 'assets/images/players/undead/skin/1/male_body_running1.png',
            'running2': 'assets/images/players/undead/skin/1/male_body_running2.png',
            'running3': 'assets/images/players/undead/skin/1/male_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/undead/body/male_body_idle.png',
          'running0': 'assets/images/players/undead/body/male_body_running0.png',
          'running1': 'assets/images/players/undead/body/male_body_running1.png',
          'running2': 'assets/images/players/undead/body/male_body_running2.png',
          'running3': 'assets/images/players/undead/body/male_body_running3.png',
        }
      },
      'female': {
        'skin': {
          0: {
            'idle': 'assets/images/players/undead/skin/0/female_skin_idle.png',
            'running0': 'assets/images/players/undead/skin/0/female_body_running0.png',
            'running1': 'assets/images/players/undead/skin/0/female_body_running1.png',
            'running2': 'assets/images/players/undead/skin/0/female_body_running2.png',
            'running3': 'assets/images/players/undead/skin/0/female_body_running3.png',
          },
          1: {
            'idle': 'assets/images/players/undead/skin/1/female_skin_idle.png',
            'running0': 'assets/images/players/undead/skin/1/female_body_running0.png',
            'running1': 'assets/images/players/undead/skin/1/female_body_running1.png',
            'running2': 'assets/images/players/undead/skin/1/female_body_running2.png',
            'running3': 'assets/images/players/undead/skin/1/female_body_running3.png',
          },
        },
        'body': {
          'idle': 'assets/images/players/undead/body/female_body_idle.png',
          'running0': 'assets/images/players/undead/body/female_body_running0.png',
          'running1': 'assets/images/players/undead/body/female_body_running1.png',
          'running2': 'assets/images/players/undead/body/female_body_running2.png',
          'running3': 'assets/images/players/undead/body/female_body_running3.png',
        }
      },
      'hair': {
        0: 'assets/images/players/undead/hair/0/hair.png',
        1: 'assets/images/players/undead/hair/1/hair.png',
      },
      'eyes': {
        0: 'assets/images/players/undead/eyes/0/eyes.png',
        1: 'assets/images/players/undead/eyes/1/eyes.png',
      },
      'mouth': {
        0: 'assets/images/players/undead/mouth/0/mouth.png',
        1: 'assets/images/players/undead/mouth/1/mouth.png',
      },
    },
  };

  ///Return the asset location of the body option
  ///
  ///raceID = its the race id of the character, you can get by using Base.races
  ///
  ///bodyOption = the specific option do you want for the body: (body, skin, hair, eyes...)
  ///
  ///gender = gender is only necessary for body and skin, false for male, true for female or use the strings
  ///
  ///selectedOption = only necessary if you selecting a body option that uses int numbers like (hair, eyes, mouth, skin)
  ///
  ///selectedSprite = only for body option thats have multiples sprites (body, skin)
  static returnBodyOptionAsset({required int raceID, String bodyOption = "body", dynamic gender = false, int selectedOption = 0, selectedSprite = 'idle'}) {
    late final String characterGender;
    //Gender Translation
    if (gender == "male" || gender == "female") {
      characterGender = gender;
    } else {
      characterGender = !gender ? 'male' : 'female';
    }
    switch (bodyOption) {
      case 'body':
        return Base.bodyOptions[Base.races[raceID]][characterGender][bodyOption][selectedSprite];
      case 'skin':
        return Base.bodyOptions[Base.races[raceID]][characterGender][bodyOption][selectedOption][selectedSprite];
      case 'hair':
        return Base.bodyOptions[Base.races[raceID]][bodyOption][selectedOption];
      case 'eyes':
        return Base.bodyOptions[Base.races[raceID]][bodyOption][selectedOption];
      case 'mouth':
        return Base.bodyOptions[Base.races[raceID]][bodyOption][selectedOption];
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

  ///Convert the string sprite location to the engine type,
  ///without the assets/images/ string
  static String convertBodyOptionAssetToEngine(String location) {
    const enginePrefixString = "assets/images/";
    if (location.startsWith(enginePrefixString)) {
      return location.substring(enginePrefixString.length);
    } else {
      return location;
    }
  }
}
