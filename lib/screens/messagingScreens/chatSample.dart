import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatSample extends StatelessWidget {
  const ChatSample(
      {Key? key,
      required this.messageText,
      required this.author,
      required this.time})
      : super(key: key);
  final String messageText;
  final String author;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return author != FirebaseAuth.instance.currentUser!.uid
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 80),
                child: ClipPath(
                  clipper: UpperNipMessageClipper(MessageType.receive),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageText,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(time.toDate()),
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 110),
                child: ClipPath(
                  clipper: LowerNipMessageClipper(MessageType.send),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          messageText,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(time.toDate()),
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
