// ignore_for_file: constant_identifier_names, camel_case_types, non_constant_identifier_names

class Language {

  static String? Translate(String value,String language){
    if (language == 'en_US'){
      return en_US[value];
    } else if (language == 'pt_BR') {
      return pt_BR[value];
    }
    return null;
  }

  static const en_US = {
    'response_yes' : 'Yes',
    'response_no' : 'No',
    'response_confirmation' : 'Are you sure?',
    'response_next' : 'Next',
    'response_back' : 'Back',

    'authentication_username' : 'Username',
    'authentication_password' : 'Password',
    'authentication_remember' : 'Remember',
    'authentication_language' : 'Language',
    'authentication_login' : 'Login',
    'authentication_login_notfound' : 'Invalid username or password',
    'authentication_register' : 'Don\'t have an account?',
    'authentication_register_text' : 'Create Account',
    'authentication_register_username' : 'Username',
    'authentication_register_password' : 'Password',
    'authentication_register_create' : 'Create',
    'authentication_register_problem_username' : 'Username needs to have 3 or more Caracters and less than 20 Caracters',
    'authentication_register_problem_existusername' : 'Username already exist',
    'authentication_register_problem_password' : 'Password needs to have 3 or more Caracters',
    'authentication_register_problem_connection' : 'Failed to connect to the Servers',
    'authentication_register_loading' : 'Loading...',
    'authentication_register_sucess' : 'Sucess',
    'authentication_register_sucess_account' : 'Account Created',

    'mainmenu_play' : 'Play',
    'mainmenu_characters' : 'Characters',
    'mainmenu_options' : 'Options',
    'mainmenu_logout' : 'Logout',
    'mainmenu_confirmation' : 'Logout and return to Login Page',

    'options_language' : 'Change Language',

    'characters_create' : 'Create Character',
    'characters_create_class' : 'Class',
    'characters_create_info' : 'Info',
  };
  static const pt_BR = {
    'response_yes' : 'Sim',
    'response_no' : 'Não',
    'response_confirmation' : 'Tem certeza?',
    'response_next' : 'Proximo',
    'response_back' : 'Voltar',

    'authentication_username' : 'Usuário',
    'authentication_password' : 'Senha',
    'authentication_remember' : 'Lembrar',
    'authentication_language' : 'Linguagem',
    'authentication_login' : 'Entrar',
    'authentication_login_notfound' : 'Nome de Usuário ou Senha são inválidos',
    'authentication_register' : 'Não tem uma conta?',
    'authentication_register_text' : 'Criar Conta',
    'authentication_register_username' : 'Seu Usuário',
    'authentication_register_password' : 'Sua Senha',
    'authentication_register_create' : 'Criar',
    'authentication_register_problem_username' : 'Usuário precisa ter 3 Caracteres e menos que 20 Caracteres',
    'authentication_register_problem_existusername' : 'Usuário já existe',
    'authentication_register_problem_password' : 'Senha precisa ter 3 ou mais Caracteres',
    'authentication_register_problem_connection' : 'Falha ao connectar no Servidor',
    'authentication_register_loading' : 'Carregando...',
    'authentication_register_sucess' : 'Sucesso',
    'authentication_register_sucess_account' : 'Conta Criada',

    'mainmenu_play' : 'Jogar',
    'mainmenu_characters' : 'Personagens',
    'mainmenu_options' : 'Opções',
    'mainmenu_logout' : 'Desconectar',
    'mainmenu_confirmation' : 'Desconectar e voltar para Pagina de Entrada?',

    'options_language' : 'Trocar Linguagem',

    'characters_create' : 'Criar Personagem',
    'characters_create_class' : 'Classe',
    'characters_create_info' : 'Info ',
  };
}