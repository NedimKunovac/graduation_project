import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ChatPage.dart';

class ActiveChats extends StatefulWidget {
  @override
  State<ActiveChats> createState() => _ActiveChatsState();
}

class _ActiveChatsState extends State<ActiveChats> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
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
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, i) {
                  List users = data[i]['users'];
                  var friend = users.where((element) =>
                      element != FirebaseAuth.instance.currentUser?.uid);
                  var user = friend.isNotEmpty
                      ? friend.first
                      : users
                          .where((element) =>
                              element == FirebaseAuth.instance.currentUser?.uid)
                          .first;
                  return FutureBuilder(
                    future: firestore.collection('Users').doc(user).get(),
                    builder: (context, AsyncSnapshot snap) {
                      return !snap.hasData
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    // ensures fullscreen
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatPage(id: user)));
                              },
                              child: Column(

                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    child: Container(

                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(35),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          child: Image.network(
                                              snap.data['profilePhotoUrl'])),
                                    ),
                                  ),
                                  Text(
                                    snap.data['name'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
