import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'advertisementWidget.dart';

/// Widget that loads the list of advertisements available on the first page
/// Called by dashboard

class ViewAdvertisements extends StatefulWidget {
  ViewAdvertisements({Key? key}) : super(key: key);

  @override
  State<ViewAdvertisements> createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {
  ///Widget list that contains advertisements
  List<Widget> availableAdvertisements = <Widget>[];

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      generator();
    });
  }

  generator() async {
    var currentUser = await FirebaseAuth.instance.currentUser?.uid;
    var userData = await FirebaseFirestore.instance.collection('Users')
        .doc(currentUser).get();
    if(userData['type'] == 2){
      availableAdvertisements.add(
        Text(
          'Your currently available volunteering opportunities:',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
      var postsReference = await FirebaseFirestore.instance.collection('Posts');
      QuerySnapshot querySnapshot = await postsReference.get();
      var postList = querySnapshot.docs.toList();
      for(var i=0;i<postList.length;i++){
        availableAdvertisements.add(
            FadeIn(
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Advertisement(id: postList[i].id, accepted: false))
        );
      }
      setState(() {});
    } else {
      availableAdvertisements.add(
        Text(
          'Your currently active posts:',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
      var postsReference = await FirebaseFirestore.instance.collection('Posts')
      .where('authorID', isEqualTo: currentUser);
      QuerySnapshot querySnapshot = await postsReference.get();
      var postList = querySnapshot.docs.toList();
      for(var i=0;i<postList.length;i++){
        availableAdvertisements.add(
            FadeIn(
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Advertisement(id: postList[i].id, accepted: false))
        );
      }
      setState(() {});
    }
  }

  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance.collection('Posts')
      .snapshots();

  @override
  Widget build(BuildContext context) {
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
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            print(data.runtimeType);
            return ListTile(
              title: Text(data['authorID']),
            );
          }).toList(),
        );
      },
    );
  }
}
