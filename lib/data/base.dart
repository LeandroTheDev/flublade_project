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
