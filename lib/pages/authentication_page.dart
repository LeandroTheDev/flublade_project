import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
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
                          //E-mail Text
                          const Text('E-mail'),
                          //E-mail Input
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
                          const Text('Password'),
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
                          //Remember CheckBox
                          Row(
                            children: [
                              //Check Box
                              Checkbox(
                                value: rememberMe,
                                onChanged: (checked) => setState(() {
                                  rememberMe = !rememberMe;
                                }),
                              ),
                              //Remember Text
                              const Text(
                                'Remember',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const SizedBox(width: 110),
                              ElevatedButton(
                                  onPressed: () {}, child: const Text('Login')),
                              const SizedBox(width: 110),
                            ],
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
