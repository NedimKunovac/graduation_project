import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'advertisementWidget.dart';

/// Widget that loads the list of advertisements available on the first page
/// Called by dashboard

class ViewAdvertisements extends StatefulWidget {
  ///Posts shown are fetched based on this data
  Map<String, dynamic> userData;

  ViewAdvertisements({Key? key, required this.userData})
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
    if(widget.userData['type']==2){
      _postsStream = FirebaseFirestore.instance
          .collection('Posts')
          .where('requirements', arrayContainsAny: widget.userData['skills'])
          .snapshots();
    }else if (widget.userData['type'] == 0) {
      _postsStream = FirebaseFirestore.instance.collection('Posts').snapshots();
    } else {
      print(widget.userData['type']);
      _postsStream = FirebaseFirestore.instance
          .collection('Posts')
          .where('authorID', isEqualTo: widget.userData['userID'])
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text('Loading'),
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            data["postID"] = document.id;
            if(widget.userData['type']==2 && data['applicationSubmitted']!=null){
              bool toggle = false;
              for (var i=0; i < data['applicationSubmitted'].length; i++) {
                if(data['applicationSubmitted'][i]==FirebaseAuth.instance.currentUser?.uid){
                  toggle=true;
                  break;
                }
              }
              if(!toggle){
                return ListBody(
                  children: [Advertisement(data: data,userType: widget.userData['type'], accepted: false)],
                );
              }
            } else{
              return ListBody(
                children: [Advertisement(data: data,userType: widget.userData['type'] , accepted: false)],
              );
            }

            return ListBody();
          }).toList(),
        );
      },
    );
    ;
  }
}
