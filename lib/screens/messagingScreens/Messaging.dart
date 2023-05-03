import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/ChatPage.dart';
import 'package:graduation_project/screens/messagingScreens/messagingHPage.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.black,
          )),
      home: messagingHPage(),
    );
  }
}
