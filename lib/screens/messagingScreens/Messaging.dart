
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/ChatPage.dart';
import 'package:graduation_project/screens/messagingScreens/messagingHPage.dart';

class Messaging extends StatelessWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          )
      ),
      routes:{
        "/" : (context)=>messagingHPage(),//Navigation
        "chatPage" : (context)=>ChatPage(),
      },
    );
  }}