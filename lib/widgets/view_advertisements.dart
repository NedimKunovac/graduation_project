import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'advertisement_widget.dart';

/// Widget that loads the list of advertisements available on the first page
/// Called by dashboard

class ViewAdvertisements extends StatefulWidget {
  ///Posts shown are fetched based on this data
  Map<String, dynamic> userData;

  ViewAdvertisements({Key? key, required this.userData}) : super(key: key);

  @override
  State<ViewAdvertisements> createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {
  ///Post loading options for volunteers, and first post set
  final List<bool> selectedLoading = <bool>[true, false, false, false];
  List<String> loadingTypes = <String>[
    'By Skills',
    'By Category',
    'All',
    'Accepted'
  ];

  ///Function that returns toggle buttons if volunteer is logged in.
  loadToggleButtons() {
    if (widget.userData['type'] == 2) {
      return Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Ink(
            width: 350,
            height: 30,
            color: Colors.transparent,
            child: GridView.count(
              primary: true,
              crossAxisCount: 4,
              //set the number of buttons in a row
              crossAxisSpacing: 5,
              //set the spacing between the buttons
              childAspectRatio: 3,
              //set the width-to-height ratio of the button,
              //>1 is a horizontal rectangle
              children: List.generate(selectedLoading.length, (index) {
                //using Inkwell widget to create a button
                return InkWell(
                    splashColor: Colors.yellow,
                    //the default splashColor is grey
                    onTap: () {
                      //set the toggle logic
                      setState(() {
                        for (int indexBtn = 0;
                            indexBtn < selectedLoading.length;
                            indexBtn++) {
                          if (indexBtn == index) {
                            selectedLoading[indexBtn] = true;
                          } else {
                            selectedLoading[indexBtn] = false;
                          }
                        }
                      });
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        //set the background color of the button when it is selected/ not selected
                        color: selectedLoading[index]
                            ? Colors.red.shade400
                            : Colors.white,
                        // here is where we set the rounded corner
                        borderRadius: BorderRadius.circular(8),
                        //don't forget to set the border,
                        //otherwise there will be no rounded corner
                        border: Border.all(color: Colors.red),
                      ),
                      child: Center(
                        child: Text(
                          loadingTypes[index],
                          style: TextStyle(
                            color: selectedLoading[index]
                                ? Colors.white
                                : Colors.red.shade400,
                          ),
                        ),
                      ),
                    ));
              }),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Reference point for posts that changes based on user
    late Stream<QuerySnapshot> _postsStream;

    ///Different post fetching based on user type and selected tab

    ///Volunteer loading
    if (widget.userData['type'] == 2) {
      if (selectedLoading[0] == true) {
        _postsStream = FirebaseFirestore.instance
            .collection('Posts')
            .where('requirements', arrayContainsAny: widget.userData['skills'])
            .snapshots();
      } else if (selectedLoading[1] == true) {
        _postsStream = FirebaseFirestore.instance
            .collection('Posts')
            .where('category', arrayContainsAny: widget.userData['interests'])
            .snapshots();
      } else if (selectedLoading[2] == true) {
        _postsStream =
            FirebaseFirestore.instance.collection('Posts').snapshots();
      } else if (selectedLoading[3] == true) {
        print(widget.userData['userID']);
        _postsStream = FirebaseFirestore.instance
            .collection('Posts')
            .where('applicationSubmitted', arrayContainsAny: [widget.userData['userID'].toString()])
            .snapshots();
      }
    } else

    ///Admin loading
    if (widget.userData['type'] == 0) {
      _postsStream = FirebaseFirestore.instance.collection('Posts').snapshots();
    }

    ///Company loading
    else {
      _postsStream = FirebaseFirestore.instance
          .collection('Posts')
          .where('authorID', isEqualTo: widget.userData['userID'])
          .snapshots();
    }

    ///StreamBuilder so posts are always up to date
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

        return Column(
          children: [
            loadToggleButtons(),
            Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  data["postID"] = document.id;
                  if (widget.userData['type'] == 2 &&
                      data['applicationSubmitted'] != null && selectedLoading[3] == false) {
                    bool toggle = false;
                    for (var i = 0;
                        i < data['applicationSubmitted'].length;
                        i++) {
                      if (data['applicationSubmitted'][i] ==
                          FirebaseAuth.instance.currentUser?.uid) {
                        toggle = true;
                        break;
                      }
                    }
                    if (!toggle) {
                      return ListBody(
                        children: [
                          Advertisement(
                              data: data,
                              userType: widget.userData['type'],
                              accepted: false)
                        ],
                      );
                    }
                  } else {
                    return ListBody(
                      children: [
                        Advertisement(
                            data: data,
                            userType: widget.userData['type'],
                            accepted: false)
                      ],
                    );
                  }

                  return ListBody();
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
    ;
  }
}
