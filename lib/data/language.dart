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
    'authentication_username' : 'Username',
    'authentication_password' : 'Password',
    'authentication_remember' : 'Remember',
    'authentication_language' : 'Language',
    'authentication_login' : 'Login',
  };
  static const pt_BR = {
    'authentication_username' : 'Usuário',
    'authentication_password' : 'Senha',
    'authentication_remember' : 'Lembrar',
    'authentication_language' : 'Linguagem',
    'authentication_login' : 'Entrar',
  };
}