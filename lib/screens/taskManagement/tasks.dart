import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:graduation_project/screens/taskManagement/task_form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks extends StatefulWidget {
  Tasks({Key? key, required this.postID}) : super(key: key);

  String? postID;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final list = [
    {
      'title': 'Title 1',
      'description': 'Some description',
      'date': 'Some date',
      'startTime': 'some time',
      'duration': 'some duration',
      'volunteers': ['a', 'b', 'c']
    },
    {
      'title': 'Title 2',
      'description': 'Some description',
      'date': 'Some date',
      'startTime': 'some time',
      'duration': 'some duration',
      'volunteers': ['a', 'b', 'c']
    },
    {
      'title': 'Title 3',
      'description': 'Some description',
      'date': 'Some date',
      'startTime': 'some time',
      'duration': 'some duration',
      'volunteers': ['a', 'b', 'c']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        itemCount: list.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) =>
        index == list.length
            ? _buildAddTask(context, widget.postID)
            : _buildTask(context, list[index]),
      ),
    );
  }
}

Widget _buildAddTask(context, postID) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskFormPage(postID: postID,)),
      );
    },
    child: DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(20),
      dashPattern: [10, 10],
      color: Colors.grey,
      strokeWidth: 2,
      child: Center(
        child: Text(
          '+ Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget _buildTask(BuildContext context, Map assignment) {
  return GestureDetector(
      onTap: ()
  =>
      showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text(assignment['title']),
              content: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(assignment['description']),
                      Text(assignment['date']),
                      Text(assignment['startTime']),
                      Text(assignment['duration']),
                      Text(assignment['volunteers'].toString()),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),),

        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.task,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(height: 30),
              Text(
                assignment['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Row(
              //
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildTasksStatus(
              //         Colors.white, Colors.white, 'Some text'),
              //     _buildTasksStatus(
              //         Colors.white, Colors.white, ''),
              //   ],
              // ),
            ],
          ),
        ),
      );
}
//
// Widget _buildTasksStatus(Color bgColor, Color txColor, String text) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
//     decoration: BoxDecoration(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(color: txColor),
//     ),
//   );
// }