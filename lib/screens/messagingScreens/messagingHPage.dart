
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/activeChats.dart';
import 'package:graduation_project/screens/messagingScreens/recentChats.dart';

class messagingHPage extends StatelessWidget {
  const messagingHPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Drawer(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            // Padding(padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 15),
            //     decoration: BoxDecoration(
            //       color:Colors.white,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           blurRadius: 10,
            //           spreadRadius: 2,
            //           offset: Offset(0, 3),
            //         )
            //       ],
            //     ),
            //
            //   ),),
            ActiveChats(),
            RecentChats(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.black54,
        child: Icon(Icons.message),



      ),

    );
  }
}