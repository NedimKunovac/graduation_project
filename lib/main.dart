import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/login.dart';
import 'screens/sign_or_log.dart';
import 'package:firebase_auth/firebase_auth.dart';

///This file serves to route user to dash if he is already logged in upon startup
///Or to the first page if no logged in user is detected

Future<void> main() async {
  //Firebase init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return SignOrLog();
  }
}
