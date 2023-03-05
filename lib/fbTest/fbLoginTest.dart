import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project/fbTest/fbLoginTestWidget.dart';
import 'package:graduation_project/main.dart';
import 'sampleHomePage.dart';

class TestSignupLogin extends StatefulWidget {
  const TestSignupLogin({Key? key,navigatorKey}) : super(key: key);

  @override
  State<TestSignupLogin> createState() => _TestSignupLoginState();
}

class _TestSignupLoginState extends State<TestSignupLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState== ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Sum Ting Wong'));
          } else if(snapshot.hasData){
           return sampleHomePage();
         } else {
           return fbLoginTestWidget(navigatorKey: navigatorKey);//TODO: Fix navigator
         }
        }
      ),
    );
  }
}
