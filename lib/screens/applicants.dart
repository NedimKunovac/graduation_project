import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/screens/profile_page.dart';

class AcceptedApplicants extends StatefulWidget {
  AcceptedApplicants({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

  @override
  State<AcceptedApplicants> createState() => _AcceptedApplicantsState();
}

class _AcceptedApplicantsState extends State<AcceptedApplicants> {
  acceptUser(userID) {
    var collection = FirebaseFirestore.instance.collection('Posts');
    collection
        .doc(widget.data['postID'])
        .update(
        {
          'applicationSubmitted': FieldValue.arrayRemove([userID]),
          'acceptedApplicants': FieldValue.arrayUnion([userID]),
        }
    );

  }
  rejectUser(userID) {
    var collection = FirebaseFirestore.instance.collection('Posts');
    collection
        .doc(widget.data['postID'])
        .update(
        {
          'applicationSubmitted': FieldValue.arrayRemove([userID]),
        }
    );
  }

  descriptionBuilder(String description) {
    var cutoffLen = 500;
    if (description.length <= cutoffLen) {
      return description;
    } else {
      return description
          .replaceRange(cutoffLen, description.length, '...');
    }
  }


  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _documentStream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.data['postID'])
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: _documentStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> firstSnapshot) {
        if (firstSnapshot.hasError) {
          return Text('Something went wrong');
        }

        if (firstSnapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return SizedBox(
          child: Column(
            children: [
              Text('Pending Applications'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: firstSnapshot.data!['applicationSubmitted'].length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(firstSnapshot.data!['applicationSubmitted'][index])
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> dataLoaded =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(userID: firstSnapshot.data!['applicationSubmitted'][index],)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            margin:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            width: 370.0,
                            height: 90.0,
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            dataLoaded['profilePhotoUrl']),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 8.0, top: 8.0, right: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              dataLoaded['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width-200,
                                              child: dataLoaded['profileInfo'] != null
                                                  ? Text(
                                                      descriptionBuilder(dataLoaded['profileInfo']),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        overflow: TextOverflow.ellipsis),
                                                    )
                                                  : SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap:() => acceptUser(firstSnapshot.data!['applicationSubmitted'][index]),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () => rejectUser(firstSnapshot.data!['applicationSubmitted'][index]),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("loading");
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Accepted Applications'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: firstSnapshot.data!['acceptedApplicants'].length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(firstSnapshot.data!['acceptedApplicants'][index])
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> dataLoaded =
                        snapshot.data!.data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(userID: firstSnapshot.data!['acceptedApplicants'][index],)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            width: 370.0,
                            height: 90.0,
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            dataLoaded['profilePhotoUrl']),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 8.0, top: 8.0, right: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              dataLoaded['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-200,
                                          child: dataLoaded['profileInfo'] != null
                                              ? Text(
                                            descriptionBuilder(dataLoaded['profileInfo']),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis),
                                          )
                                              : SizedBox.shrink()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("loading");
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
