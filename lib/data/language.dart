// ignore_for_file: constant_identifier_names, camel_case_types, non_constant_identifier_names

class Language {
  static String? Translate(String value, String language) {
    if (language == 'en_US') {
      return en_US[value];
    } else if (language == 'pt_BR') {
      return pt_BR[value];
    }
    return null;
  }

  static const en_US = {
    //Response
    'response_yes': 'Yes',
    'response_no': 'No',
    'response_confirmation': 'Are you sure?',
    'response_next': 'Next',
    'response_back': 'Back',
    'response_select': 'Select',
    'response_create': 'Create',
    'response_remove': 'Remove',
    'response_ok': 'Ok',
    'response_incorrect': 'Incorrect',
    'response_error':
        'Ops, There was a problem with your processing, try again later',
    'response_loading': 'Loading Please Wait...',
    'response_equip': 'Equip',
    'response_damage': 'Damage',
    'response_sellprice': 'Sell Price',
    'response_unequipitem': 'Unequip Item',
    'response_unequip': 'Unequip',
    //Authentication
    'authentication_username': 'Username',
    'authentication_password': 'Password',
    'authentication_remember': 'Remember',
    'authentication_language': 'Language',
    'authentication_login': 'Login',
    'authentication_login_notfound': 'Invalid username or password',
    'authentication_register': 'Don\'t have an account?',
    'authentication_register_text': 'Create Account',
    'authentication_register_username': 'Username',
    'authentication_register_password': 'Password',
    'authentication_register_create': 'Create',
    'authentication_register_problem_username':
        'Username needs to have 3 or more Caracters and less than 20 Caracters',
    'authentication_register_problem_existusername': 'Username already exist',
    'authentication_register_problem_password':
        'Password needs to have 3 or more Caracters',
    'authentication_register_problem_connection':
        'Failed to connect to the Servers',
    'authentication_register_loading': 'Loading...',
    'authentication_register_sucess': 'Sucess',
    'authentication_register_sucess_account': 'Account Created',
    //Main Menu
    'mainmenu_play': 'Play',
    'mainmenu_characters': 'Characters',
    'mainmenu_options': 'Options',
    'mainmenu_logout': 'Logout',
    'mainmenu_confirmation': 'Logout and return to Login Page',
    //Options
    'options_language': 'Change Language',
    //Characters
    'characters_create': 'Create Character',
    'characters_create_class': 'Class',
    'characters_create_level': 'Level',
    'characters_create_gold': 'Gold',
    'characters_create_location': 'Location',
    'characters_create_info': 'Info',
    'characters_create_name': 'Character Name',
    'characters_create_error':
        'Ops, there\'s was a problem creating your character try again later',
    'characters_create_error_namelimit':
        'Character name cannot be longer than 10 characters',
    'characters_create_error_empty':
        'You need to make a name to your character',
    'characters_class_archer_info':
        'Archer\nFast and agile, good aim, less chance of missing, fragile, greater chance of dodging, little ease in robberies.',
    'characters_class_assassin_info':
        'Assassin\nSilent, barely audible, fragile, high ease of stealing, high dodge chance, high damage if caught off guard.',
    'characters_class_bard_info':
        'Bard\nDoesn\'t know how to be silent, bad at stealing, robust, good at cheering up, healer, manages to tame easily, raises the spirits of the group and himself, can manage.',
    'characters_class_beastmaster_info':
        'Beast Master\nFriend of Nature, animals do not attack him, can be tamed very easily, very fragile, tamed animals have 10% additional stats.',
    'characters_class_berserk_info':
        'Berserk\nEnemy of all, can\'t be silent, can\'t use elemental magic, the less health the more damage and regeneration, can\'t tame, difficulty creating friendships, extremely robust.',
    'characters_class_druid_info':
        'Druid\nFriend of Nature, can transform into an animal from each biome, great healer, fragile if not transformed, can\'t dodge in human form or use healing spells, can easily tame, high health regeneration .',
    'characters_class_mage_info':
        'Mage\nHigh mana and regeneration, elemental spells deal 10% more damage, difficult to create friendships, extremely fragile.',
    'characters_class_paladin_info':
        'Paladin\nExtremely robust, shield spells are 10% more effective, incoming heals are 10% stronger, great healer, excellent at making friends, easy to tame.',
    'characters_class_priest_info':
        'Priest\nExcellent healer, excellent at making friends, 5% of damage dealt heals you and 1% to allies, reduces damage taken from dark spells by 50%, damage from light spells is 10% more effective extremely fragile.',
    'characters_class_trickmagician_info':
        'Trick Magician\nPolymorph spells cost no mana, extremely silent, immune to persuasion, great at making friends, fragile.',
    'characters_class_weaponsmith_info':
        'Weaponsmith\nForged weapons are 10% more effective, great at making friends, robust, can create wards, chance to forge with enchantment.',
    'characters_class_witch_info':
        'Witch\nDamage with dark spells 10% more effective, 10% of damage dealt is converted to life, extremely fragile, can charm enemies, excellent at making friends, takes 10% more damage from light spells.',
    'characters_class_archer': 'Archer',
    'characters_class_assassin': 'Assassin',
    'characters_class_bard': 'Bard',
    'characters_class_beastmaster': 'Beastmaster',
    'characters_class_berserk': 'Berserk',
    'characters_class_druid': 'Druid',
    'characters_class_mage': 'Mage',
    'characters_class_paladin': 'Paladin',
    'characters_class_priest': 'Priest',
    'characters_class_trickmagician': 'Trickmagician',
    'characters_class_weaponsmith': 'Weaponsmith',
    'characters_class_witch': 'Witch',
    'characters_remove': 'Type "DELETE" to remove the character',
    //Locations
    'locations_prologue': 'Prologue',
    //PauseMenu
    'pausemenu_pause': 'Pause',
    'pausemenu_continue': 'Continue',
    'pausemenu_options': 'Options',
    'pausemenu_disconnect': 'Disconnect',
    //Ingame Texts
    'dialog_npc_wizard_name': 'Wizard',
    'dialog_npc_wizard_prologue1': 'Hello',
    'dialog_npc_wizard_prologue2': 'Test',
    //Battle Texts
    'battle_life': 'Life',
    'battle_mana': 'Mana',
    'battle_attack': 'Attack',
    'battle_defence': 'Defence',
    'battle_loot': 'Loots',
    'battle_loot_all': 'Take All',
    'battle_loot_exit': 'Exit',
    'battle_loot_selected': 'Selected',
    //Items Name
    'items_gold': 'Gold',
    'items_gold_desc':
        'In nature, gold is produced from the collision of two neutron stars. Gold is widely used in jewellery, as well as a store of value.',
    'items_woodsword': 'Wooden Sword',
    'items_woodsword_desc': 'In war, it is not normally used, but in combat training yes, to simply not hurt your tutor or person you are training.',
    'items_thread': 'Thread',
    'items_thread_desc': 'Made from twisted fibers of linen, cotton, silk, synthetics, etc., used in sewing, embroidery, lace, fabrication',
    'items_cloth': 'Cloth',
    'items_cloth_desc': 'Cloth, made from threads, on looms where the interweaving of the filaments will be carried out, which will later be transformed into cloth.',
  };
  static const pt_BR = {
    //Response
    'response_yes': 'Sim',
    'response_no': 'Não',
    'response_confirmation': 'Tem certeza?',
    'response_next': 'Proximo',
    'response_back': 'Voltar',
    'response_select': 'Selecionar',
    'response_create': 'Criar',
    'response_remove': 'Remover',
    'response_ok': 'Ok',
    'response_incorrect': 'Incorreto',
    'response_error':
        'Ops, Aconteceu um problema com seu processamento, tente novamente mais tarde',
    'response_loading': 'Carregando Por Favor Espere...',
    'response_equip': 'Equipar',
    'response_damage': 'Dano',
    'response_sellprice': 'Preço de Venda',
    'response_unequipitem': 'Desequipar Item',
    'response_unequip': 'Desequipar',
    //Authentication
    'authentication_username': 'Usuário',
    'authentication_password': 'Senha',
    'authentication_remember': 'Lembrar',
    'authentication_language': 'Linguagem',
    'authentication_login': 'Entrar',
    'authentication_login_notfound': 'Nome de Usuário ou Senha são inválidos',
    'authentication_register': 'Não tem uma conta?',
    'authentication_register_text': 'Criar Conta',
    'authentication_register_username': 'Seu Usuário',
    'authentication_register_password': 'Sua Senha',
    'authentication_register_create': 'Criar',
    'authentication_register_problem_username':
        'Usuário precisa ter 3 Caracteres e menos que 20 Caracteres',
    'authentication_register_problem_existusername': 'Usuário já existe',
    'authentication_register_problem_password':
        'Senha precisa ter 3 ou mais Caracteres',
    'authentication_register_problem_connection':
        'Falha ao connectar no Servidor',
    'authentication_register_loading': 'Carregando...',
    'authentication_register_sucess': 'Sucesso',
    'authentication_register_sucess_account': 'Conta Criada',
    //Main Menu
    'mainmenu_play': 'Jogar',
    'mainmenu_characters': 'Personagens',
    'mainmenu_options': 'Opções',
    'mainmenu_logout': 'Desconectar',
    'mainmenu_confirmation': 'Desconectar e voltar para Pagina de Entrada?',
    //Options
    'options_language': 'Trocar Linguagem',
    //Characters
    'characters_create': 'Criar Personagem',
    'characters_create_class': 'Classe',
    'characters_create_level': 'Nível',
    'characters_create_gold': 'Ouro',
    'characters_create_location': 'Local',
    'characters_create_info': 'Info ',
    'characters_create_name': 'Nome do Personagem',
    'characters_create_error':
        'Ops, tivemos um problema ao criar seu personagem tente novamente mais tarde',
    'characters_create_error_namelimit':
        'Nome do personagem não pode ter mais de 10 caracteres',
    'characters_class_archer_info':
        'Arqueiro\nVeloz e ágil, boa pontaria, menos chance de errar, frágil, maior chance de esquiva, pequena facilidade em roubos.',
    'characters_class_assassin_info':
        'Assassino\nSilencioso, quase não da pra ouvir, frágil, facilidade alta em roubos, chances altas de esquiva, danos altos se pego desprevinido.',
    'characters_class_bard_info':
        'Bardo\nNão sabe ser silencioso, péssimo em roubos, robusto, bom para alegrar, curandeiro, consegue domesticar com facilidade, aumenta o astral do grupo e de si mesmo, consegue se virar.',
    'characters_class_beastmaster_info':
        'Domador de Fera\nAmigo da Natureza, animais não o atacam, consegue domesticar com muita facilidade, muito frágil, animais domesticados tem 10% de status adicionais.',
    'characters_class_berserk_info':
        'Berserk\nInimigo de todos, não consegue ser silencioso, não consegue usar magias elementais, quanto menos vida mais dano e regeneração, não pode domesticar, dificuldade em criar amizades, extremamente robusto.',
    'characters_class_druid_info':
        'Druida\nAmigo da Natureza, pode se transformar em um animal de cada bioma, ótimo curandeiro, frágil se não transformado, não consegue esquivar na forma humana nem usar magias de cura, pode domesticar com facilidade, regeneração alta de vida.',
    'characters_class_mage_info':
        'Mago\nMana e regeneração altas, magias elementais dão 10% mais de dano, dificuldade em criar amizades, extremamente frágil.',
    'characters_class_paladin_info':
        'Paladino\nExtremamente robusto, magias de escudo são 10% mais eficazes, curas recebidas são 10% mais fortes, ótimo curandeiro, excelente em fazer amizades, facilidade em domesticar.',
    'characters_class_priest_info':
        'Sacerdote\nExcelente curandeiro, excelente em fazer amizades, 5% do dano causado cura você e 1% para aliados, reduz 50% do dano recebido de magias escuras, dano de magias da luz são 10% mais eficazes extremamente frágil.',
    'characters_class_trickmagician_info':
        'Mágico\nMagias de polimorfe não custam mana, extremamente silencioso, imune a persuação, ótimo em fazer amizades, frágil.',
    'characters_class_weaponsmith_info':
        'Armeiro\nArmas forjadas são 10% mais eficazes, ótimo em fazer amizades, robusto, consegue criar sentinelas, chance de forjar com encantamento.',
    'characters_class_witch_info':
        'Bruxa\nDanos com magias escuras 10% mais eficazes, 10% do dano causado é convertido em vida, extremamente frágil, consegue encantar inimigos, excelente em fazer amizades, recebe 10% mais de dano em magias da luz.',
    'characters_class_archer': 'Arqueiro',
    'characters_class_assassin': 'Assassino',
    'characters_class_bard': 'Bardo',
    'characters_class_beastmaster': 'Domador de Fera',
    'characters_class_berserk': 'Berserk',
    'characters_class_druid': 'Druida',
    'characters_class_mage': 'Mago',
    'characters_class_paladin': 'Paladino',
    'characters_class_priest': 'Sacerdote',
    'characters_class_trickmagician': 'Mágico',
    'characters_class_weaponsmith': 'Armeiro',
    'characters_class_witch': 'Bruxa',
    'characters_remove': 'Digite "DELETE" para remover o personagem',
    //Locations
    'locations_prologue': 'Prólogo',
    //PauseMenu
    'pausemenu_pause': 'Pausado',
    'pausemenu_continue': 'Continuar',
    'pausemenu_options': 'Opções',
    'pausemenu_disconnect': 'Desconectar',
    //Ingame Texts
    'dialog_npc_wizard_name': 'Mago',
    'dialog_npc_wizard_prologue1': 'Olá',
    'dialog_npc_wizard_prologue2': 'Test',
    //Battle Texts
    'battle_life': 'Vida',
    'battle_mana': 'Mana',
    'battle_attack': 'Atacar',
    'battle_defence': 'Defender',
    'battle_loot': 'Saque',
    'battle_loot_all': 'Pegar Tudo',
    'battle_loot_exit': 'Sair',
    'battle_loot_selected': 'Selecionado',
    //Items Name
    'items_gold': 'Ouro',
    'items_gold_desc':
        'Na natureza, o ouro é produzido a partir da colisão de duas estrelas de nêutrons. O ouro é utilizado de forma generalizada em joalharia, bem como reserva de valor',
    'items_woodsword': 'Espada de Madeira',
    'items_woodsword_desc': 'Na guerra, não é normalmente utilizada, mas em treinos de combate sim, para simplesmente não ferir seu tutor ou pessoa que está treinando.',
    'items_thread': 'Linha',
    'items_thread_desc': 'Fio de fibras torcidas de linho, algodão, seda, sintéticas etc., usado em costuras, bordados, rendas, fabricação',
    'items_cloth': 'Pano',
    'items_cloth_desc': 'Feito com linhas, em teares onde será realizado o entrelaçamento dos filamentos que posteriormente serão transformados em panos.'
  };
}
