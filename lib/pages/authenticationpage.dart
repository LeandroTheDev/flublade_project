// ignore_for_file: use_build_context_synchronously
import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/savedatas.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  //Texts Controllers
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController registerUsername = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController serverAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context);
    final settings = Provider.of<Settings>(context);
    final screenSize = MediaQuery.of(context).size;
    final server = Provider.of<Server>(context, listen: false);

    //Register Modal
    registerModal() {
      if (server.serverName == "") {
        Dialogs.alertDialog(context: context, message: 'authentication_no_connection');
        return;
      }
      //Modal Bottom
      showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.0),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: screenSize.height * 0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Create Account Text
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('authentication_register_text', options.language) ?? 'Create Account',
                                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            //Username Text
                            FittedBox(
                              child: Text(
                                Language.Translate('authentication_register_username', options.language) ?? 'Your Username',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25),
                              ),
                            ),
                            //Username Input
                            Stack(
                              children: [
                                //Background Box Color and Decoration
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 209, 209, 209),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: screenSize.width * 0.95,
                                    height: 40,
                                  ),
                                ),
                                //Input
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.topLeft,
                                  width: screenSize.width * 0.95,
                                  height: 45,
                                  child: TextFormField(controller: registerUsername),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            //Password Text
                            FittedBox(
                              child: Text(
                                Language.Translate('authentication_register_password', options.language) ?? 'Your Password',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25),
                              ),
                            ),
                            //Password Input
                            Stack(
                              children: [
                                //Background Box Color and Decoration
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 209, 209, 209),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: screenSize.width * 0.95,
                                    height: 40,
                                  ),
                                ),
                                //Input
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.topLeft,
                                  width: screenSize.width * 0.95,
                                  height: 45,
                                  child: TextFormField(obscureText: true, controller: registerPassword),
                                ),
                              ],
                            ),
                            //Create Button
                            FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: SizedBox(
                                  width: screenSize.width,
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      SizedBox(
                                        height: 50,
                                        width: 125,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            //Loading Widget
                                            Dialogs.loadingDialog(context: context);
                                            final Map result = await Server.sendMessage(
                                              context,
                                              address: '/createAcc',
                                              body: {
                                                "username": registerUsername.text,
                                                "password": registerPassword.text,
                                                "language": options.language,
                                              },
                                            );
                                            //Account Rules Check
                                            if (result["message"] == 'Success') {
                                              Navigator.pop(context);
                                              //Show Result Dialog
                                              showDialog(
                                                  barrierColor: const Color.fromARGB(167, 0, 0, 0),
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                      //Sucess Text
                                                      title: Text(
                                                        Language.Translate('authentication_register_sucess', options.language) ?? 'Failed to connect to the Servers',
                                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                                      ),
                                                      content: Text(
                                                        Language.Translate('authentication_register_sucess_account', options.language) ?? 'Failed to connect to the Servers',
                                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                                      ),
                                                      actions: [
                                                        Center(
                                                            child: ElevatedButton(
                                                          onPressed: () {
                                                            registerUsername = TextEditingController();
                                                            registerPassword = TextEditingController();
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('Ok'),
                                                        ))
                                                      ],
                                                    );
                                                  }).then((result) {
                                                registerUsername = TextEditingController();
                                                registerPassword = TextEditingController();
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              Navigator.pop(context);
                                              Server.errorTreatment(result["message"], context);
                                              return;
                                            }
                                          },
                                          child: Text(
                                            Language.Translate('authentication_register_create', options.language) ?? 'Create',
                                            style: const TextStyle(fontSize: 45),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).then((value) => Future.delayed(const Duration(milliseconds: 100)).then((value) => FocusManager.instance.primaryFocus?.unfocus()));
    }

    //Server Edit
    serverModal() {
      //Modal Bottom
      showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.0),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: screenSize.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Server IP Text
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('response_serverAddress', options.language) ?? 'Server IP',
                                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            //Server INPUT
                            Stack(
                              children: [
                                //Background Box Color and Decoration
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 209, 209, 209),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: screenSize.width * 0.95,
                                    height: 40,
                                  ),
                                ),
                                //Input
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.topLeft,
                                  width: screenSize.width * 0.95,
                                  height: 45,
                                  child: TextFormField(
                                    controller: serverAddress,
                                    autofocus: true,
                                  ),
                                ),
                              ],
                            ),
                            //Select Button
                            FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SizedBox(
                                  width: screenSize.width,
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      SizedBox(
                                        height: 30,
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            //Debug Activation
                                            if (serverAddress.text == "debug") {
                                              options.changeDebug(true);
                                              options.changeId(0);
                                              options.changeUsername('debugger');
                                              options.changeLanguage('en_US');
                                              options.changeToken('0000');
                                              Navigator.pushReplacementNamed(context, '/mainmenu');
                                              return;
                                            } else {
                                              options.changeDebug(false);
                                            }
                                            Dialogs.loadingDialog(context: context);
                                            //Try connection
                                            server.changeServerAddress(serverAddress.text);
                                            final Map result = await Server.sendMessage(context, address: '/getServerData', body: {}, get: true);
                                            if (result['message'] == 'Success') {
                                              //Verify Game Version
                                              final PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                              if (result['gameVersion'] != packageInfo.version) {
                                                Navigator.pop(context);
                                                Dialogs.alertDialog(context: context, message: 'response_version_mismatch');
                                                return;
                                              }
                                              //Update Server
                                              setState(() {
                                                server.changeServerName(result['serverName']);
                                                SaveDatas.setServerAddress(serverAddress.text);
                                                SaveDatas.setServerName(result['serverName']);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              Server.errorTreatment(result['message'], context);
                                              return;
                                            }
                                          },
                                          child: FittedBox(
                                            child: Text(
                                              Language.Translate('response_connect', options.language) ?? 'Connect',
                                              style: const TextStyle(fontSize: 45),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).then((value) => Future.delayed(const Duration(milliseconds: 100)).then((value) => FocusManager.instance.primaryFocus?.unfocus()));
    }

    //Login
    login() async {
      //Verify if user is connected to a server
      if (server.serverName == "") {
        Dialogs.alertDialog(context: context, message: 'authentication_no_connection');
        return;
      }
      settings.changeIsLoading(value: true);
      final Map result = await Server.sendMessage(context, address: '/login', body: {"username": username.text, "password": password.text});
      //Proceed to connection
      if (result['message'] == 'Success') {
        if (options.remember) {
          //Update Providers
          options.changeId(result['id']);
          options.changeUsername(result['username']);
          options.changeToken(result['token']);
          //Update Save
          SaveDatas.setUsername(options.username);
          SaveDatas.setToken(result['token']);
          SaveDatas.setRemember(options.remember);
          SaveDatas.setId(options.id);
        } else {
          //Update Providers
          options.changeId(result['id']);
          options.changeUsername(result['username']);
          options.changeToken(result['token']);
        }
        settings.changeIsLoading(value: false);
        Navigator.pushReplacementNamed(context, '/mainmenu');
      } else {
        Server.errorTreatment(result['message'], context);
      }
      settings.changeIsLoading(value: false);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.2),
            //The white box in the center of the page
            SizedBox(
              height: screenSize.height * 0.6,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(400.0),
                    child: Stack(
                      children: [
                        //Background Image
                        Container(
                          width: 5600,
                          height: 5600,
                          //Decoration of the box (Circular and Color)
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Image.asset('assets/images/menu/authentication_background.png', fit: BoxFit.fill, color: const Color.fromARGB(33, 255, 255, 255), colorBlendMode: BlendMode.modulate),
                        ),
                        //Auth
                        SizedBox(
                          width: 5600,
                          height: 5600,
                          //Texts and TextForms in the white box
                          child: Padding(
                            padding: const EdgeInsets.all(200.0),
                            child: FittedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Welcome Text
                                  Row(
                                    children: [
                                      //Server Name
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 240,
                                        height: 20,
                                        child: FittedBox(
                                          child: Text(
                                            server.serverName == "" ? "FLUBLADE" : server.serverName,
                                            style: const TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ),
                                      //Spacer
                                      const SizedBox(width: 20),
                                      //Server Change
                                      SizedBox(
                                        width: 50,
                                        height: 20,
                                        child: FittedBox(
                                          child: ElevatedButton(
                                            onPressed: () => serverModal(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              //Server Text
                                              child: Text(
                                                Language.Translate('response_servers', options.language) ?? 'Servers',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  //Username Text
                                  Text(Language.Translate('authentication_username', options.language) ?? 'Username'),
                                  //Username Input
                                  Stack(
                                    children: [
                                      //Background Box Color and Decoration
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 209, 209, 209),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          width: 310,
                                          height: 40,
                                        ),
                                      ),
                                      //Input7
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.topLeft,
                                        width: 310,
                                        height: 45,
                                        child: TextFormField(controller: username),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  //Password Text
                                  Text(Language.Translate('authentication_password', options.language) ?? 'Password'),
                                  //Password Input
                                  Stack(
                                    children: [
                                      //Background Box Color and Decoration
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 209, 209, 209),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          width: 310,
                                          height: 40,
                                        ),
                                      ),
                                      //Input
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.topLeft,
                                        width: 310,
                                        height: 45,
                                        child: TextFormField(controller: password),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  //Remember CheckBox and Language
                                  SizedBox(
                                    width: 310,
                                    child: Row(
                                      children: [
                                        //Check Box
                                        Checkbox(
                                          value: options.remember,
                                          onChanged: (checked) => options.changeRemember(),
                                        ),
                                        //Remember Text
                                        Text(
                                          Language.Translate('authentication_remember', options.language) ?? 'Remember',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        //Language Button
                                        ElevatedButton(
                                            onPressed: () {
                                              Dialogs.changeLanguage(context, super.widget);
                                            },
                                            child: Text(Language.Translate('authentication_language', options.language) ?? 'Language'))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  //Login Button
                                  settings.isLoading
                                      ? const SizedBox(
                                          width: 310,
                                          height: 30,
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              //Circular Progress Indicator
                                              SizedBox(
                                                width: 20,
                                                height: 30,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                                  child: CircularProgressIndicator(),
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ))
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 100),
                                          width: 310,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () => login(),
                                            child: Text(Language.Translate('authentication_login', options.language) ?? 'Login'),
                                          ),
                                        ),
                                  //Register
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextButton(
                                      onPressed: () => registerModal(),
                                      child: Text(Language.Translate('authentication_register', options.language) ?? 'Don\'t have an account?'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.2),
          ],
        ),
      ),
    );
  }
}
