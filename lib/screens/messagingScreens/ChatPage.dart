import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/chatSample.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageFieldController = TextEditingController();
  var roomId;

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: AppBar(
            leadingWidth: 30,
            title: StreamBuilder(
                stream:
                    firestore.collection('Users').doc(widget.id).snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  return !snapshot.hasData
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                snapshot.data!['profilePhotoUrl'],
                                height: 45,
                                width: 45,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    snapshot.data!['name'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(left: 10),
                                //   child: !snapshot.data!['date_time'].isNotEmpty? SizedBox.shrink() : Text(
                                //     'Last seen : ${DateFormat('hh:mm a').format(snapshot.data!['date_time'].toDate()).toString()}',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w300
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        );
                }),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: firestore.collection('Rooms').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                List<QueryDocumentSnapshot?> allData = snapshot.data!.docs
                    .where((element) =>
                        element['users'].contains(widget.id) &&
                        element['users']
                            .contains(FirebaseAuth.instance.currentUser!.uid))
                    .toList();
                QueryDocumentSnapshot? data =
                    allData.isNotEmpty ? allData.first : null;
                if (data != null) {
                  roomId = data.id;
                }

                return data == null
                    ? SizedBox.shrink()
                    : Scaffold(
                        body: StreamBuilder(
                            stream: data.reference
                                .collection('messages')
                                .orderBy('datetime', descending: true)
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snap) {
                              return !snap.hasData
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
                                      child: ListView.builder(
                                        // padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 80),
                                        itemCount: snap.data!.docs.length,
                                        reverse: true,
                                        itemBuilder: (context, i) {
                                          return ChatSample(
                                              messageText: snap.data!.docs[i]
                                                  ['message'],
                                              author: snap.data!.docs[i]
                                                  ['sent_by'],
                                              time: snap.data!.docs[i]
                                                  ['datetime']);
                                        },
                                      ),
                                    );
                            }),
                      );
              } else {
                return Center(
                    child: const Text(
                        'Welcome to the chat! Try writing a messsage'));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            }
          }),
      bottomSheet: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Container(
                alignment: Alignment.centerRight,
                width: 290,
                child: TextField(
                  controller: messageFieldController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  if (messageFieldController.text.toString() != '') {
                    if (roomId != null) {
                      Map<String, dynamic> data = {
                        'message': messageFieldController.text.trim(),
                        'sent_by': FirebaseAuth.instance.currentUser!.uid,
                        'datetime': DateTime.now()
                      };
                      firestore.collection('Rooms').doc(roomId).update({
                        'last_message_time': DateTime.now(),
                        'last_message': messageFieldController.text,
                      });
                      firestore
                          .collection('Rooms')
                          .doc(roomId)
                          .collection('messages')
                          .add(data);
                    } else {
                      Map<String, dynamic> data = {
                        'message': messageFieldController.text.trim(),
                        'sent_by': FirebaseAuth.instance.currentUser!.uid,
                        'datetime': DateTime.now()
                      };
                      firestore.collection('Rooms').add({
                        'users': [
                          widget.id,
                          FirebaseAuth.instance.currentUser!.uid
                        ],
                        'last_message_time': DateTime.now(),
                        'last_message': messageFieldController.text,
                      }).then((value) {
                        value.collection('messages').add(data);
                      });
                    }
                  }
                  messageFieldController.clear();
                },
                icon: Icon(Icons.send, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
