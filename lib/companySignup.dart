import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanySignup extends StatefulWidget {
  const CompanySignup({Key? key}) : super(key: key);

  @override
  State<CompanySignup> createState() => _CompanySignupState();
}

class _CompanySignupState extends State<CompanySignup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
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
        ),
      ),
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
              return Container(
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
                        inputFile(label: 'Name of the company:'),
                        inputFile(label: 'Representative of the company:'),
                        inputFile(label: 'VAT number:'),
                        inputFile(label: 'Company image:'),
                        inputFile(label: 'Email:', controller: emailController),
                        inputFile(
                            label: 'Password:',
                            obscureText: true,
                            controller: passwordController),
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
