import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.2),
            //The white box in the center of the page
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(400.0),
                child: Container(
                  width: 5600,
                  height: 5600,
                  //Decoration of the box (Circular and Color)
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  //Texts and TextForms in the white box
                  child: Padding(
                    padding: const EdgeInsets.all(200.0),
                    child: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Welcome Text
                          const Text(
                            'FLUBLADE',
                            style: TextStyle(
                                letterSpacing: 4, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 20),
                          //Username Text
                          Text(Language.Translate('authentication_username',
                                  options.language) ??
                              'Username'),
                          //Username Input
                          Stack(
                            children: [
                              //Background Box Color and Decoration
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 209, 209, 209),
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
                                child: TextFormField(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //Password Text
                          Text(Language.Translate('authentication_password',
                                  options.language) ??
                              'Password'),
                          //Password Input
                          Stack(
                            children: [
                              //Background Box Color and Decoration
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 209, 209, 209),
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
                                child: TextFormField(),
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
                                  value: rememberMe,
                                  onChanged: (checked) => setState(() {
                                    rememberMe = !rememberMe;
                                  }),
                                ),
                                //Remember Text
                                Text(
                                  Language.Translate('authentication_remember',
                                          options.language) ??
                                      'Remember',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                //Language Button
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(Language.Translate(
                                                      'authentication_language',
                                                      options.language) ??
                                                  'Language'),
                                              content: Column(
                                                children: [
                                                  //en_US
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        options.changeLanguage(
                                                            'en_US');
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    super
                                                                        .widget));
                                                      },
                                                      child: const Text(
                                                        'English',
                                                      ),
                                                    ),
                                                  ),
                                                  //pt_BR
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        options.changeLanguage(
                                                            'pt_BR');
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    super
                                                                        .widget));
                                                      },
                                                      child: const Text(
                                                        'Português',
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(Language.Translate(
                                            'authentication_language',
                                            options.language) ??
                                        'Language'))
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          //Login Button
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            width: 310,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(Language.Translate(
                                      'authentication_login',
                                      options.language) ??
                                  'Login'),
                            ),
                          )
                        ],
                      ),
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
