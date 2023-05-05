import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/task.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:graduation_project/screens/taskManagement/details.dart';

class Tasks extends StatelessWidget {
  final tasksList = Task.generatedTasks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        itemCount: tasksList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => tasksList[index].isLast ?? false
            ? _buildAddTask()
            : _buildTask(context, tasksList[index]),
      ),
    );
  }
}

Widget _buildAddTask() {
  return DottedBorder(
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
  );
}

Widget _buildTask(BuildContext context, Task task) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DetailPage(task)),
      );
    },
    child: Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: task.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            task.iconData,
            color: task.iconColor,
            size: 35,
          ),
          SizedBox(height: 30),
          Text(
            task.title!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTasksStatus(
                  task.btnColor!, task.iconColor!, '${task.left} left'),
              _buildTasksStatus(
                  Colors.white, task.iconColor!, '${task.done} done'),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTasksStatus(Color bgColor, Color txColor, String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: txColor),
    ),
  );
}