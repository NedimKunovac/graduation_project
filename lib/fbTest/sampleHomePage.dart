import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sampleHomePage extends StatefulWidget {
  const sampleHomePage({Key? key}) : super(key: key);

  @override
  State<sampleHomePage> createState() => _sampleHomePageState();
}

class _sampleHomePageState extends State<sampleHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Welcome '),
            Text(user.email!),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.arrow_back, size: 32,),
            label: Text('Sign Out'),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      )
    );
  }
}
