import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/signUpRouter.dart';
import 'package:graduation_project/signup.dart';
import 'signorlog.dart';
import 'fbTest/fbLoginTest.dart';


final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    home:MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignOrLog();
  }
}

