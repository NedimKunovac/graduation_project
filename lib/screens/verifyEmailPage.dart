import 'dart:async';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project/screens/dashboard.dart';
import 'package:flash/flash.dart';
import 'package:graduation_project/utilities/flash_bar.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  // void initState(){
  //   super.initState();
  //
  //   isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //   if(!isEmailVerified){
  //     sendVerificationEmail();
  //   }
  // }
  //
  // Future sendVerificationEmail() async{
  //   try{
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Verify Email'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A verification email has been sent to your email address. '
                    'You will be automatically redirected when you confirm your email',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ))
            ],
          ),
        ));
  }

}
