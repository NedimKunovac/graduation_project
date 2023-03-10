import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flashBar.dart';
import 'package:email_validator/email_validator.dart';

class CompanySignup extends StatefulWidget {
  const CompanySignup({Key? key}) : super(key: key);

  @override
  State<CompanySignup> createState() => _CompanySignupState();
}

class _CompanySignupState extends State<CompanySignup> {
  final formKey = GlobalKey<FormState>();
  final compNameController = TextEditingController();
  final repNameController = TextEditingController();
  final vatNumController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearControllers() {
    compNameController.clear();
    repNameController.clear();
    vatNumController.clear();
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
          'name': compNameController.text.trim(),
          'rep': repNameController.text.trim(),
          'type': 1,
          'vatNum': vatNumController.text.trim(),
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
            } else if (snapshot.hasData) {
              return Dashboard();
            } else if (snapshot.hasError) {
              return Center(child: Text('Sum Ting Wong'));
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
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  height: MediaQuery.of(context).size.height - 50,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Company title:',
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
                                      controller: compNameController,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      validator: (value) => value != null &&
                                              value.length < 3
                                          ? 'Please enter your company\'s name'
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Company representative\'s name:',
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
                                      controller: repNameController,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      validator: (value) => value != null &&
                                              value.length < 3
                                          ? 'Please enter your company representative\'s name'
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Company VAT Number:',
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
                                      keyboardType: TextInputType.number,
                                      controller: vatNumController,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      validator: (value) => value != null &&
                                              value.length != 12
                                          ? 'Please enter a proper VAT Number \nA VAT Number containts 12 numbers'
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
                                  'Sign up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: createAccount),
                          ),
                        ]),
                  ),
                ),
              );
            }
          });
  }
}
