// ignore_for_file: use_build_context_synchronously
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dialogs {
  ///Disconnect will prompt a message to ask user if he wants to disconnect or not,
  ///by accepting will change the main page to authentication page and remove all credentials from local
  static void disconnectDialog({
    required BuildContext context,
  }) {
    final options = Provider.of<Options>(context, listen: false);
    resetLocalAccountData() {
      options.changeUsername('');
      options.changeToken('');
      options.changeRemember(value: false);
      options.changeId(0);
      SaveDatas.setRemember(false);
      Provider.of<Gameplay>(context, listen: false).changeCharacters({});
    }

    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              Language.Translate('response_confirmation', options.language) ?? 'Are you sure?',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(
              Language.Translate('mainmenu_confirmation', options.language) ?? 'MsgContext',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: [
              //Yes
              ElevatedButton(
                onPressed: () {
                  resetLocalAccountData();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthenticationPage()), (route) => false);
                },
                child: Text(
                  Language.Translate('response_yes', options.language) ?? 'Yes',
                ),
              ),
              //No
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  Language.Translate('response_no', options.language) ?? 'No',
                ),
              ),
            ],
          );
        });
  }

  ///Prompt a error dialog that will message what the error and change the main page to authentication,
  ///Use this only for fatal errors
  ///
  ///Receives errorMsg as parameter, this will be the text to be show in center of error dialog
  static errorDialog({
    required String errorMsg,
    required BuildContext context,
  }) {
    final options = Provider.of<Options>(context, listen: false);
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Sad face
              title: Text(
                ':(',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              //Error information
              content: Text(
                Language.Translate(errorMsg, options.language) ?? "Invalid Session",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              //Ok Button
              actions: [
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/authenticationpage', (route) => false);
                  },
                  child: const Text('Ok'),
                ))
              ],
            ),
          );
        });
  }

  ///Show a alert message
  ///
  ///Arguments:
  ///
  ///title = Defines the text to show in top of alert
  ///
  ///message = Defines the text to be show in center of alert
  ///
  ///messageButton = Defines the text to be show on back button
  ///
  ///returnFunction = Defines the function to be called after click the button, the function receives a BuildContext as parameter
  static void alertDialog({
    required BuildContext context,
    String title = "response_alert",
    String message = "",
    String messageButton = "Ok",
    bool cancel = false,
    Function? returnFunction,
  }) {
    final language = Provider.of<Options>(context, listen: false).language;
    showDialog(
      context: context,
      barrierDismissible: cancel,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return cancel;
          },
          child: Dialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //Title
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      Language.Translate(title, language) ?? 'Language Error',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  //Message
                  Text(Language.Translate(message, language) ?? 'Language Error',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  const SizedBox(height: 12.0),
                  //Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: returnFunction == null ? () => Navigator.pop(context) : () => returnFunction(context), child: Text(messageButton)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///Show a Language dialog to change the application language
  static Future<void> changeLanguage(context, widget) async {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context, listen: false);
    //Upload to Server
    change(String language) async {
      //Update Datas
      options.changeLanguage(language);
      SaveDatas.setLanguage(language);
      //Pop the Dialog
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => widget));
    }

    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Language Text
              title: Text(
                Language.Translate('authentication_language', options.language) ?? 'Language',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: SizedBox(
                width: screenSize.width * 0.5,
                height: screenSize.height * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //en_US
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            change('en_US');
                          },
                          child: const Text(
                            'English',
                          ),
                        ),
                      ),
                      //pt_BR
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            change('pt_BR');
                          },
                          child: const Text(
                            'Português',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ///Loading dialog display a circular indicator
  static void loadingDialog({required BuildContext context, bool cancel = false}) {
    final options = Provider.of<Options>(context, listen: false);
    showDialog(
      barrierColor: const Color.fromARGB(167, 0, 0, 0),
      context: context,
      barrierDismissible: cancel,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => cancel,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //Language Text
            title: Text(
              Language.Translate('authentication_register_loading', options.language) ?? 'Loading',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: const Padding(
              padding: EdgeInsets.all(50.0),
              child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}
