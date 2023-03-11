import 'package:flutter/material.dart';
import 'package:graduation_project/signUpRouter.dart';
import 'login.dart';

class SignOrLog extends StatefulWidget {
  const SignOrLog({Key? key}) : super(key: key);

  @override
  State<SignOrLog> createState() => _SignOrLogState();
}

class _SignOrLogState extends State<SignOrLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          //double infinity makes it as big as the parent allows
          height: MediaQuery.of(context as BuildContext).size.height,
          //media query makes it as big as per screen
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //even distribution of space
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'App that serves as a channel through which volunteers and companies are able to connect and communicate with each other',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context as BuildContext).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/introduction.png"))),
              ),
              Column(
                children: <Widget>[
                  //Login button
                  MaterialButton(
                    color: Colors.red.shade400,
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context as BuildContext,
                          MaterialPageRoute(builder: (context) => LoginPage(passedEmail: '', newAccount: false)));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  //sign up button
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpRouter()));
                    },
                    color: Colors.red.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
