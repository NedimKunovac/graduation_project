import 'package:email_validator/email_validator.dart';

import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flashBar.dart';

class LoginPage extends StatefulWidget {
  String passedEmail;
  bool newAccount;

  LoginPage({Key? key, required this.passedEmail, required this.newAccount}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearControllers() {
    passwordController.clear();
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      clearControllers();
    } on FirebaseAuthException catch (e) {
      print(e);

      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3), context: context, message: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Sum Ting Wong'));
          } else if (snapshot.hasData) {
            return Dashboard();
          } else {
            emailController.text=widget.passedEmail;
            return Scaffold(
              backgroundColor: Colors.white,
              //return button in the app bar
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black,
                    )),
              ),
              body: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ///LOGIN TEXT
                        Column(
                          children: <Widget>[
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Login to your account',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        ///PICTURE
                        Container(
                          padding: EdgeInsets.only(top: 100),
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/permission.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),

                        ///FORM
                        Form(
                          key: formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ///FORM
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    child: Column(
                                      children: <Widget>[
                                        ///EMAIL
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Email:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              obscureText: false,
                                              controller: emailController,
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              validator: (email) => email !=
                                                          null &&
                                                      !EmailValidator.validate(
                                                          email)
                                                  ? 'Please enter a valid email'
                                                  : null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),

                                        ///PASSWORD
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Password:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              obscureText: true,
                                              controller: passwordController,
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 6
                                                  ? 'Please enter at least 6 characters'
                                                  : null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ]),
                        ),

                        ///BUTTON
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: EdgeInsets.only(top: 30, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.red.shade400,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: signIn),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            );
          }
          ;
        });
  }
}
