import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/task_form_page.dart';
import 'package:graduation_project/screens/taskManagement/go_premium.dart';
import 'package:graduation_project/screens/taskManagement/tasks.dart';
import 'package:graduation_project/widgets/view_advertisements.dart';

import 'colors.dart';

class TrelloHomePage extends StatelessWidget {
  TrelloHomePage({Key? key, required this.postID}) : super(key: key);

  String? postID;
  @override

  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: Text('Welcome Company. This is the page where you can see all the tasks you assigned for this job',
              style: TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold
              ),),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child:Tasks(postID: postID), )
        ],
      ),
    );


  }
}

