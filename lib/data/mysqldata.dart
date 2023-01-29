import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySQL {
  //Connection
  static final database = MySqlConnection.connect(
    ConnectionSettings(
      host: '192.168.1.25',
      port: 3306,
      user: 'flubladeGuest',
      password: 'i@Dhs4e5E%fGz&ngbY2m&AGRCVlskBUrrCnsYFUze&fhxehb#j',
      db: 'flublade',
    ),
  );

  //Account Creation
  static Future<String> createAccount(
      {required String name,
      required String password,
      required String language}) async {
    //Connection to the database
    final connection = await database;
    try {
      //Insert new account to the database
      await connection.query(
          'insert into accounts (username, password, language) values (?, ?, ?)',
          [name, password, language]);
      return 'sucess';
    } catch (error) {
      if(error.toString().contains('Duplicate entry')){
        return 'exists';
      }
      return 'failed';
    }
  }

  //Loading
  static void loadingWidget(
      {required BuildContext context, required String language}) {
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //Language Text
            title: Text(
              Language.Translate('authentication_register_loading', language) ??
                  'Loading',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: const Padding(
              padding: EdgeInsets.all(50.0),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator()),
            ),
          );
        });
  }
}
