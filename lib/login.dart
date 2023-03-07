import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //return button in the app bar
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
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
              return SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
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
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    child: Column(
                                      children: <Widget>[
                                        inputFile(
                                            label: 'Email',
                                            controller: emailController),
                                        inputFile(
                                            label: 'Password',
                                            obscureText: true,
                                            controller: passwordController)
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 70, left: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: MaterialButton(
                                        minWidth: double.infinity,
                                        height: 60,
                                        color: Colors.red.shade400,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                )
                              ]),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 100),
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/permission.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                      ],
                    )),
              );
            }
            ;
          }),
    );
  }
}

//Widget for text fields
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
