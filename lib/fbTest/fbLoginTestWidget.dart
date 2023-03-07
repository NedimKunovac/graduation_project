import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project/main.dart';

class fbLoginTestWidget extends StatefulWidget {

  const fbLoginTestWidget({Key? key, navigatorKey}): super(key: key);


  @override
  State<fbLoginTestWidget> createState() => _fbLoginTestWidgetState();
}

class _fbLoginTestWidgetState extends State<fbLoginTestWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

   //navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 4),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon:Icon(Icons.lock_open, size: 32,),
            label: Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn,
          ),
          SizedBox(height: 10),
          RichText(
              text: TextSpan(
                text: 'No account?',
                children: [
                  TextSpan(
                    text: ' Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    )
                  )
                ]
              ),
          )
        ],
      ),
    );
  }
}

