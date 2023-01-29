import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  //Texts Controllers
  var username = TextEditingController();
  var password = TextEditingController();
  var registerUsername = TextEditingController();
  var registerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context);
    final screenSize = MediaQuery.of(context).size;

    //Error Dialog
    errorDialog({
      required String errorMsgTitle,
      required String errorMsgContext,
    }) {
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
                ':(',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                Language.Translate(errorMsgTitle, options.language) ??
                    errorMsgContext,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ))
              ],
            );
          });
    }

    //Register Modal
    registerModal() {
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
            return SizedBox(
              height: screenSize.height * 0.8,
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
                              Language.Translate('authentication_register_text',
                                      options.language) ??
                                  'Create Account',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      //Username Text
                      FittedBox(
                        child: Text(
                          Language.Translate('authentication_register_username',
                                  options.language) ??
                              'Your Username',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25),
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
                          Language.Translate('authentication_register_password',
                                  options.language) ??
                              'Your Password',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25),
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
                            child: TextFormField(controller: registerPassword),
                          ),
                        ],
                      ),
                      //Create Button
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: SizedBox(
                            width: screenSize.width,
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 100,
                                  width: 250,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      //Username Error
                                      if (registerUsername.text.length < 3 ||
                                          registerUsername.text.length > 20) {
                                        errorDialog(
                                            errorMsgTitle:
                                                'authentication_register_problem_username',
                                            errorMsgContext:
                                                'Username needs to have 3 or more Caracters');
                                        //Password Error
                                      } else if (registerPassword.text.length <
                                          3) {
                                        errorDialog(
                                            errorMsgTitle:
                                                'authentication_register_problem_password',
                                            errorMsgContext:
                                                'Password needs to have 3 or more Caracters');
                                        //Connect
                                      } else {
                                        MySQL.loadingWidget(
                                            context: context,
                                            language: options.language);
                                        final result =
                                            await MySQL.createAccount(
                                                name: registerUsername.text,
                                                password: registerPassword.text,
                                                language: options.language);
                                        if (result == 'sucess') {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          showDialog(
                                                  barrierColor:
                                                      const Color.fromARGB(
                                                          167, 0, 0, 0),
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      32.0))),
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .scaffoldBackgroundColor,
                                                      //Language Text
                                                      title: Text(
                                                        Language.Translate(
                                                                'authentication_register_sucess',
                                                                options
                                                                    .language) ??
                                                            'Failed to connect to the Servers',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      content: Text(
                                                        Language.Translate(
                                                                'authentication_register_sucess_account',
                                                                options
                                                                    .language) ??
                                                            'Failed to connect to the Servers',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      actions: [
                                                        Center(
                                                            child:
                                                                ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('Ok'),
                                                        ))
                                                      ],
                                                    );
                                                  })
                                              .then((result) {
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/authenticationpage'));
                                                  });
                                        } else if (result == 'exists') {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          errorDialog(
                                              errorMsgTitle:
                                                  'authentication_register_problem_existusername',
                                              errorMsgContext:
                                                  'Username already exist');
                                        } else if (result == 'failed') {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          errorDialog(
                                              errorMsgTitle:
                                                  'authentication_register_problem_connection',
                                              errorMsgContext:
                                                  'Failed to connect to the Servers');
                                        }
                                      }
                                    },
                                    child: Text(
                                      Language.Translate(
                                              'authentication_register_create',
                                              options.language) ??
                                          'Create',
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
                      const SizedBox(height: 240),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    //Change Language
    changeLanguage() {
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
                Language.Translate(
                        'authentication_language', options.language) ??
                    'Language',
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
                            options.changeLanguage('en_US');
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget));
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
                            options.changeLanguage('pt_BR');
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget));
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
            );
          });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.2),
            //The white box in the center of the page
            FittedBox(
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
                      child: Image.asset('assets/authentication_image.png',
                          fit: BoxFit.fill,
                          color: const Color.fromARGB(33, 255, 255, 255),
                          colorBlendMode: BlendMode.modulate),
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
                              const Text(
                                'FLUBLADE',
                                style: TextStyle(
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w900),
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
                                    child: TextFormField(controller: username),
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
                                      fillColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                                      value: options.remember,
                                      onChanged: (checked) => options.changeRemember(),
                                    ),
                                    //Remember Text
                                    Text(
                                      Language.Translate(
                                              'authentication_remember',
                                              options.language) ??
                                          'Remember',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    //Language Button
                                    ElevatedButton(
                                        onPressed: () {
                                          changeLanguage();
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
                              ),
                              //Register
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextButton(
                                  onPressed: () {
                                    registerModal();
                                  },
                                  child: Text(Language.Translate(
                                          'authentication_register',
                                          options.language) ??
                                      'Don\'t have an account?'),
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
            SizedBox(height: screenSize.height * 0.2),
          ],
        ),
      ),
    );
  }
}
