
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/chatBottomSheet.dart';
import 'package:graduation_project/screens/messagingScreens/chatSample.dart';

class ChatPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      //for custom size appBar
      appBar: PreferredSize( preferredSize: Size.fromHeight(70.0),
        child: Padding(padding: EdgeInsets.only(top: 5),
          child: AppBar(
            leadingWidth: 30,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/images/user.png',
                    height: 45,
                    width: 45,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Programmer',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),

                ),
              ],
            ),

          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 80),
        children: [
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
        ],),
      bottomSheet: ChatBottomSheet(),

    );

  }
}