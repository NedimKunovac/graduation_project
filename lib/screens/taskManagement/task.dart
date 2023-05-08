import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/colors.dart';

class Task {
  IconData? iconData;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  num? left;
  num? done;
  List<Map<String, dynamic>>? desc;
  bool? isLast;

  Task(
      {this.iconData,
      this.title,
      this.bgColor,
      this.iconColor,
      this.left,
      this.done,
      this.desc,
      this.btnColor,
      this.isLast = false});

  static List<Task> generatedTasks() {
    ///Generated tasks can be replaced with our backend
    return [
      Task(
          iconData: Icons.person_rounded,
          title: 'Task 1',
          bgColor: kYellowLight,
          iconColor: kYellowDark,
          btnColor: kYellow,
          left: 3,
          done: 1,
          desc: [
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
          ]),
      Task(
        iconData: Icons.cases_rounded,
        title: 'Task 2',
        bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
        left: 5,
        done: 10,
      ),
      Task(
        iconData: Icons.cases_rounded,
        title: 'Task 2',
        bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
        left: 5,
        done: 10,
      ),
      Task(
        iconData: Icons.cases_rounded,
        title: 'Task 2',
        bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
        left: 5,
        done: 10,
      ),
      Task(
          iconData: Icons.favorite_rounded,
          title: 'Task 3',
          bgColor: kBlueLight,
          iconColor: kBlueDark,
          btnColor: kBlue,
          left: 3,
          done: 5,
          desc: [
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
              'title': 'Meeting with a boss',
              'slot': '2:00 - 3:00 pm',
              'tlColor': Colors.grey.withOpacity(0.3),
              'bgColor': kRedLight
            },
            {
              'time': '3:00 pm',
              'title': '',
              'slot': '',
              'tlColor': Colors.grey.withOpacity(0.3),
            },
          ]),
      Task(isLast: true)
    ];
  }
}
