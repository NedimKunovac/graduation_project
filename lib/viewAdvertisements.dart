import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'advertisementWidget.dart';

/// Widget that loads the list of advertisements available on the first page
/// Called by dashboard

class ViewAdvertisements extends StatefulWidget {
  ///Posts shown are fetched based on this data
  String? userID;
  var userType;

  ViewAdvertisements({Key? key, required this.userID, required this.userType})
      : super(key: key);

  @override
  State<ViewAdvertisements> createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {

  ///Reference point for posts that changes based on user
  late final Stream<QuerySnapshot> _postsStream;

  @override
  Widget build(BuildContext context) {

    ///Different post fetching based on user type
    if (widget.userType == 2 || widget.userType == 0) {
      _postsStream = FirebaseFirestore.instance.collection('Posts').snapshots();
    } else {
      _postsStream = FirebaseFirestore.instance
          .collection('Posts')
          .where('authorID', isEqualTo: widget.userID)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListBody(
              children: [Advertisement(data: data, accepted: false)],
            );
          }).toList(),
        );
      },
    );
    ;
  }
}
