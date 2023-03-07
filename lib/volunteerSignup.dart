import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class VolunteerSignup extends StatefulWidget {
  const VolunteerSignup({Key? key}) : super(key: key);

  @override
  State<VolunteerSignup> createState() => _VolunteerSignupState();
}

class _VolunteerSignupState extends State<VolunteerSignup> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  addLoginInfo() async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return false;
  }
  Future createAccount() async {
    if(await addLoginInfo()){
     try {
       String? userReference = FirebaseAuth.instance.currentUser?.uid;
       userReference.toString();
       FirebaseFirestore usersCollection = FirebaseFirestore.instance;
       await usersCollection
           .collection('Users')
           .doc(userReference!)
           .set({'name': fullNameController.text.trim(),
       'type':2,});

     } on FirebaseException catch (e) {
       print(e);
     }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          )),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Sum Ting Wong'));
            } else if (snapshot.hasData) {
              return Dashboard();
            } else {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  height: MediaQuery.of(context).size.height - 50,
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Sign up',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Create your account.',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            inputFile(
                                label: 'Name and Surname:',
                                controller: fullNameController),
                            inputFile(label: 'Date of birth:'),
                            inputFile(label: 'Skills:'),
                            inputFile(
                                label: 'Email:', controller: emailController),
                            inputFile(
                                label: 'Password:',
                                obscureText: true,
                                controller: passwordController)
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
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
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: createAccount,
                          ),
                        ),
                      ]),
                ),
              );
            }
          }),
    );
  }
}

Widget inputFile({label, obscureText = false, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
