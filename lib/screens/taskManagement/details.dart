import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/screens/dashboard.dart';
import 'package:graduation_project/screens/taskManagement/task.dart'; //task.dart
import 'package:graduation_project/screens/taskManagement/date_picker.dart'; //date_picker.dart
import 'package:graduation_project/screens/taskManagement/task_timeline.dart'; //task_timeline.dart
import 'package:graduation_project/screens/taskManagement/task_title.dart';
import 'package:graduation_project/screens/taskManagement/trello_home_page.dart';
import 'package:graduation_project/widgets/view_advertisements.dart';

import 'colors.dart'; //task_title.dart

class DetailPage extends StatelessWidget {

  DetailPage();



  @override
  Widget build(BuildContext context) {
    Task something = Task(
        iconData: Icons.person_rounded,
        title: 'Task 1',
        bgColor: Colors.green,
        iconColor: Colors.blue,
        btnColor: Colors.red,
        left: 3,
        done: 1,
        desc:[
          {
            'time': '9:00 am',
            'title': 'Go for a walk with dog',
            'slot': '9:00 - 10:00 am',
            'tlColor': kRedDark,
            'bgColor': kRedLight,
          },
          {
            'time': '10:00 am',
            'title': 'Shot on dribble',
            'slot': '10:00 - 12:00 am',
            'tlColor': kBlueDark,
            'bgColor': kBlueLight,
          },
          {
            'time': '11:00 am',
            'title': '',
            'slot': '',
            'tlColor': kBlueDark,
          },
          {
            'time': '12:00 am',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
          {
            'time': '1:00 pm',
            'title': 'Call with client',
            'slot': '1:00 - 2:00 pm',
            'tlColor': Colors.grey.withOpacity(0.3),
            'bgColor': kYellowLight,
          },
          {
            'time': '2:00 pm',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
          {
            'time': '3:00 pm',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
        ]
    );
    final detailList = something.desc;
    return Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
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
            detailList == null
                ? SliverFillRemaining(
                    child: Container(
                        color: Colors.white,
                        child: Center(
                            child: Text(
                          'No task today',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ))))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, index) => TaskTimeline(detailList[index]),
                        childCount: detailList.length),
                  )
          ],
        ));
  }

  Widget _buildAppBar(BuildContext context) {
    Task something = Task(
        iconData: Icons.person_rounded,
        title: 'Task 1',
        bgColor: Colors.green,
        iconColor: Colors.blue,
        btnColor: Colors.red,
        left: 3,
        done: 1,
        desc:[
          {
            'time': '9:00 am',
            'title': 'Go for a walk with dog',
            'slot': '9:00 - 10:00 am',
            'tlColor': kRedDark,
            'bgColor': kRedLight,
          },
          {
            'time': '10:00 am',
            'title': 'Shot on dribble',
            'slot': '10:00 - 12:00 am',
            'tlColor': kBlueDark,
            'bgColor': kBlueLight,
          },
          {
            'time': '11:00 am',
            'title': '',
            'slot': '',
            'tlColor': kBlueDark,
          },
          {
            'time': '12:00 am',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
          {
            'time': '1:00 pm',
            'title': 'Call with client',
            'slot': '1:00 - 2:00 pm',
            'tlColor': Colors.grey.withOpacity(0.3),
            'bgColor': kYellowLight,
          },
          {
            'time': '2:00 pm',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
          {
            'time': '3:00 pm',
            'title': '',
            'slot': '',
            'tlColor': Colors.grey.withOpacity(0.3),
          },
        ]
    );
    return SliverAppBar(
      expandedHeight: 90,
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 20,
      ),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('View post'),
              value: 'View post',
            ),
            PopupMenuItem(
              child: Text('Leave'),
              value: 'Leave',
            ),
          ],
          onSelected: (value) {
            if (value == 'View post') {

            } else if (value == 'Leave') {
             Navigator.pop(context);
            }
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${something.title} tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'You have ${something.left} tasks for today!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
