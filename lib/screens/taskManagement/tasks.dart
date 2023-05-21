import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:graduation_project/screens/taskManagement/task_form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Tasks extends StatefulWidget {
  Tasks({Key? key, required this.postID}) : super(key: key);

  String? postID;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postID)
          .collection('Tasks')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            itemCount: snapshot.data!.docs.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => index == snapshot.data!.docs.length
                ? _buildAddTask(context, widget.postID)
                : _buildTask(
                    context,
                    snapshot.data!.docs[index].data() as Map<dynamic, dynamic>, widget.postID,snapshot.data!.docs[index].id),
          ),
        );
      },
    );
  }
}

Widget _buildAddTask(context, postID) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskFormPage(
                  postID: postID,
                )),
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

Widget _buildTask(
    BuildContext context, Map assignment, String? postID, String? assignmentID) {
  return InkWell(
    onTap: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(assignment['title']),
            Text(DateFormat.yMMMMd('en_US')
                .format(assignment['date'].toDate())
                .toString(),style: TextStyle(fontSize: 14),),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 200,
          child: Column(
            children: [
              Row(

                  children:[
              Flexible(
                child: Text(assignment['description'],
                  style: TextStyle(fontSize: 14)
                ),
              ),

              ]),
              SizedBox(height: 10),

              Row(
                children: [
                  Text('Event time:',style: TextStyle(fontSize: 14)),
                  SizedBox(width: 30),
                  Text(assignment['time'],style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Event duration:',style: TextStyle(fontSize: 14)),
                  SizedBox(width: 20),
                  Text(assignment['duration'],style: TextStyle(fontSize: 14)),
                ],
              ),
              assignment['workers']==[] ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where(FieldPath.documentId, whereIn: assignment['workers'])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }


                  return Expanded(
                      child: ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return SizedBox(
                        height: 20,
                        child: ListTile(
                          title: Text(data['name']),
                        ),
                      );
                    }).toList(),
                  ));


                },
              ) : SizedBox.shrink(),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.task,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  assignment['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            '${DateFormat.yMMMMd('en_US').format(assignment['date'].toDate()).toString()} - ${assignment['duration']} mins',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 3),
          Flexible(
            child: Text(
              assignment['description'],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Are you sure you want to edit this task?'),
                      content: Text(
                          'Think twice before editing. Editing a task cannot be undone!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskFormPage(
                                    taskID: assignmentID,
                                    postID: postID,
                                    data: assignment,
                                  )),
                            );
                          },
                          child: const Text('Yes I want to edit this task', style: TextStyle(
                            color: Colors.red,
                          ),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                child: CircleAvatar(
                  child: Icon(Icons.edit),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Are you sure you want to delete this task?'),
                      content: Text(
                          'Think twice before deleting. Deleting a task cannot be undone!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('Posts').doc(postID).collection('Tasks').doc(assignmentID).delete();
                            Navigator.pop(context, 'Yes I want to delete this task');
                          },
                          child: const Text('Yes I want to delete this task', style: TextStyle(
                            color: Colors.red,
                          ),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                child: CircleAvatar(
                  child: Icon(Icons.delete),
                ),
              )
            ],
          )
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
