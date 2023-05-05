import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/task.dart';//task.dart
import 'package:graduation_project/screens/taskManagement/date_picker.dart';//date_picker.dart
import 'package:graduation_project/screens/taskManagement/task_timeline.dart';//task_timeline.dart
import 'package:graduation_project/screens/taskManagement/task_title.dart';//task_title.dart
class DetailPage extends StatelessWidget {

  final Task task;
  DetailPage(this.task);
  @override
  Widget build(BuildContext context) {
    final detailList = task.desc;
    return Scaffold(
        backgroundColor: Colors.black,

        body:CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DatePicker(),
                    TaskTitle(),
                  ],
                ),
              ),
            ),
            detailList == null ?
            SliverFillRemaining(
                child: Container(
                    color: Colors.white,
                    child: Center(child: Text('No task today',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18
                      ),)))
            ) :
            SliverList(
              delegate: SliverChildBuilderDelegate((_, index) => TaskTimeline(detailList[index]),
                  childCount: detailList.length
              ),
            )
          ],
        )

    );
  }
  Widget _buildAppBar(BuildContext context){
    return SliverAppBar(
      expandedHeight: 90,
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 20,),

      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${task.title} tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,

              ),

            ),
            SizedBox(height: 5),
            Text('You have ${task.left} tasks for today!',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700]
              ),)
          ],
        ),
      ),
    );

  }
}