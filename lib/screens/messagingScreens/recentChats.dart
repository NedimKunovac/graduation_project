import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/ChatPage.dart';
import 'package:intl/intl.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: StreamBuilder(
          stream: firestore.collection('Rooms').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List data = !snapshot.hasData
                ? []
                : snapshot.data!.docs
                    .where((element) => element['users']
                        .toString()
                        .contains(FirebaseAuth.instance.currentUser!.uid))
                    .toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) {
                List users = data[i]['users'];
                var friend = users.where((element) =>
                    element != FirebaseAuth.instance.currentUser!.uid);
                var user = friend.isNotEmpty
                    ? friend.first
                    : users
                        .where((element) =>
                            element == FirebaseAuth.instance.currentUser!.uid)
                        .first;
                return FutureBuilder(
                    future: firestore.collection('Users').doc(user).get(),
                    builder: (context, AsyncSnapshot snap) {
                      return !snap.hasData
                          ? SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(// ensures fullscreen
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                    id: user,
                                                  )));
                                },
                                child: Container(
                                  height: 65,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: Image.network(
                                          snap.data['profilePhotoUrl'],
                                          height: 65,
                                          width: 65,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snap.data['name'].length < 22
                                                  ? snap.data['name']
                                                  : snap.data['name']
                                                      .replaceRange(
                                                          22,
                                                          snap.data['name']
                                                              .length,
                                                          '...'),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              data[i]['last_message'].length <
                                                      35
                                                  ? data[i]['last_message']
                                                  : data[i]['last_message']
                                                      .replaceRange(
                                                          35,
                                                          data[i]['last_message']
                                                              .length,
                                                          '...'),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  data[i]['last_message_time']
                                                      .toDate()),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Container(
                                            //   height: 23,
                                            //   width: 23,
                                            //   alignment: Alignment.center,
                                            //   decoration: BoxDecoration(
                                            //       color: Colors.black54,
                                            //       borderRadius: BorderRadius.circular(25)
                                            //
                                            //   ),
                                            //   child: Text('1',//number for messages
                                            //     style: TextStyle(
                                            //       color: Colors.white,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                    });
              },
            );
          }),
    );
  }
}
