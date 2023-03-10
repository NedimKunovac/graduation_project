import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'flashBar.dart';

class VolunteerSignup extends StatefulWidget {
  const VolunteerSignup({Key? key}) : super(key: key);

  @override
  State<VolunteerSignup> createState() => _VolunteerSignupState();
}

class _VolunteerSignupState extends State<VolunteerSignup> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dateinputController = TextEditingController();
  DateTime? pickedDate;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearControllers() {
    fullNameController.clear();
    dateinputController.clear();
    emailController.clear();
    passwordController.clear();
  }


  addLoginInfo() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);

      flashBar.showBasicsFlash(
          duration: Duration(seconds: 3), context: context, message: e.message);
    }
    return false;
  }

  Future createAccount() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (await addLoginInfo()) {
      try {
        String? userReference = FirebaseAuth.instance.currentUser?.uid;
        userReference.toString();
        FirebaseFirestore usersCollection = FirebaseFirestore.instance;
        await usersCollection.collection('Users').doc(userReference!).set({
          'name': fullNameController.text.trim(),
          'type': 2,
          'dateOfBirth': Timestamp.fromDate(pickedDate!),
        });

        clearControllers();
      } on FirebaseException catch (e) {
        print(e);
      }
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
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  brightness: Brightness.light,
                  automaticallyImplyLeading: false,
                  title: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                  )),
              body: SingleChildScrollView(
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
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Full Name:',
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
                                    controller: fullNameController,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) =>
                                        value != null && value.length < 3
                                            ? 'Please enter your full name'
                                            : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Date of Birth:',
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
                                    controller: dateinputController,
                                    readOnly: true,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                      onTap: () async {
                                        pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now().subtract(const Duration(days: 6575)),
                                            firstDate: DateTime.now().subtract(const Duration(days: 20075)), //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime.now().subtract(const Duration(days: 6575)),
                                        );

                                        if(pickedDate != null ){
                                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
                                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                          //you can implement different kind of Date Format here according to your requirement

                                          setState(() {
                                            dateinputController.text = formattedDate; //set output date to TextField value.
                                          });
                                        }else{
                                          print("Date is not selected");
                                        }
                                      },
                                    validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Please enter your date of birth'
                                        : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? 'Please enter a valid email'
                                        : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) => value != null &&
                                            value.length < 6
                                        ? 'Please enter at least 6 characters'
                                        : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
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
                        ),
                      ]),
                ),
              ),
            );
          }
        });
  }
}
