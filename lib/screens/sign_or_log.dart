import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/forgotPasswordPage.dart';
import 'package:graduation_project/screens/sign_up_pick.dart';
import 'login.dart';

///First page of the app, serves to allow user to navigate to login or sign-up pages
///Hence the name Sign or Log

class SignOrLog extends StatefulWidget {
  const SignOrLog({Key? key}) : super(key: key);

  @override
  State<SignOrLog> createState() => _SignOrLogState();
}

class _SignOrLogState extends State<SignOrLog> {




  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(FirebaseAuth.instance.currentUser?.uid!=null)
        Navigator.push(
            context as BuildContext,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                    passedEmail: '', newAccount: false)));

    });



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
              //Text on top of page
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
              //Picture on first page
              Container(
                height: MediaQuery.of(context as BuildContext).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/introduction.png"))),
              ),
              //Buttons that route to login or sign up
              Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  //Login button
                  MaterialButton(
                    color: Colors.red.shade400,
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context as BuildContext,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                  passedEmail: '', newAccount: false)));
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
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Text('Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                      fontSize: 12
                    ),),
                    onTap: ()=>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage())),
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
