import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/task.dart'; //task.dart
import 'package:graduation_project/screens/taskManagement/date_picker.dart'; //date_picker.dart
import 'package:graduation_project/screens/taskManagement/task_timeline.dart'; //task_timeline.dart
import 'package:graduation_project/screens/taskManagement/task_title.dart';
import 'package:intl/intl.dart';
import 'colors.dart'; //task_title.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.data}) : super(key: key);
  Map? data;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    print('Current user UID - ${FirebaseAuth.instance.currentUser?.uid}');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.data!['postID'])
          .collection('Tasks')
          .where('workers', arrayContainsAny: [
        FirebaseAuth.instance.currentUser?.uid
      ]).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        }

        return Scaffold(
            backgroundColor: Colors.grey,
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, snapshot.data!.docs.length),
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
                        ListView(
                          shrinkWrap:true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return InkWell(
                              onTap: ()=>showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(data['title']),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Text(data['description']),
                                        Text(DateFormat.yMMMMd('en_US')
                                            .format(data['date'].toDate())
                                            .toString()),
                                        Text(data['time']),
                                        Text(data['duration']),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Users')
                                              .where(FieldPath.documentId, whereIn: data['workers'])
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
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                    return SizedBox(
                                                      height: 20,
                                                      child: ListTile(
                                                        title: Text(data['name']),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ));
                                          },
                                        ),
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
                              child: ListTile(
                                title: Text(data['title']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['description']),
                                    Text(DateFormat.yMMMMd('en_US')
                                        .format(data['date'].toDate())
                                        .toString()),
                                    Text(data['time']),
                                    Text(data['duration']),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildAppBar(BuildContext context, int noTasks) {
    return SliverAppBar(
      expandedHeight: 55,
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
              '${widget.data!['title']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'You have ${noTasks} task(s) for today!',
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
