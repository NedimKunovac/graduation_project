import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../widgets/tag_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {

  String? userID;

  ProfilePage({Key? key,  this.userID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.userID!=null
          ? FirebaseFirestore.instance.collection('Users').where(FieldPath.documentId, whereIn: [widget.userID]).snapshots()
          : FirebaseFirestore.instance.collection('Users').where(FieldPath.documentId, whereIn: [FirebaseAuth.instance.currentUser?.uid]).snapshots(),
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

        Map <dynamic,dynamic> loadedData = snapshot.data!.docs.first.data() as Map<dynamic, dynamic>;

        return Scaffold(
          appBar: widget.userID!=null ? AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
            ),
            title: Text(
              'User profile page',
              style: TextStyle(
                color: Colors.black
              ),
            ),
          ): null,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                    Widget>[
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(loadedData['profilePhotoUrl']),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    loadedData['name'],
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  loadedData['type'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 2.0),
                      loadedData['type'] == 0 ? Text(
                        'ADMIN',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ): SizedBox.shrink(),
                      loadedData['type'] == 1 ?Text(
                        'Company',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ): SizedBox.shrink(),
                      loadedData['type'] == 2 ?Text(
                        'Volunteer',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ): SizedBox.shrink(),
                    ],
                  ) : SizedBox.shrink(),
                  loadedData['dateOfBirth'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Age: ${(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(loadedData['dateOfBirth'].seconds * 1000)).inDays / 365).round()}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  loadedData['rep'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        'Representative: ${loadedData['rep']}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ) : SizedBox.shrink(),
                  loadedData['vatNum'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 2.0),
                      Text(
                        'VAT Number: ${loadedData['vatNum']}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ) : SizedBox.shrink(),

                  loadedData['dateOfBirth'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 2.0),
                      Text(
                        'Date of birth: ${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(loadedData['dateOfBirth'].seconds * 1000))}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),



                  loadedData['profileInfo'] != null && loadedData['profileInfo'] != ''
                      ? Column(
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Profile info:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all( color: Colors.grey.shade500),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.red,
                        //   border: Border.all(color: Colors.grey),
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        padding: EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Text(
                            loadedData['profileInfo'].toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  loadedData['skills'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Skills:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RenderTags(
                          addedChips:
                          List<String>.from(loadedData['skills'] as List)),
                    ],
                  )
                      : SizedBox.shrink(),
                  loadedData['interests'] != null
                      ? Column(
                    children: [
                      SizedBox(height: 18.0),
                      Text(
                        'Interests:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: loadedData['interests'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 28,
                            child: ListTile(
                              leading: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              title: Text(loadedData['interests'][index]),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  SizedBox(height: 16.0),
                  // Text(
                  //   'Pending applications:',
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 16.0),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.vertical,
                  //   child: Column(
                  //     children: <Widget>[
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.red,
                  //           border: Border.all(color: Colors.grey),
                  //           borderRadius: BorderRadius.circular(10.0),
                  //         ),
                  //         margin: EdgeInsets.only(right: 8.0),
                  //         width: 400.0,
                  //         height: 80.0,
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Image(
                  //               image: NetworkImage(
                  //                   'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                  //               height: 50,
                  //               width: 70,
                  //             ),
                  //             Expanded(
                  //               child: Container(
                  //                 margin: EdgeInsets.only(left: 40.0, right: 8.0),
                  //                 child: Text(
                  //                   'Name of the company',
                  //                   style: TextStyle(color: Colors.white, fontSize: 18),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ]),
              ),
            ));
      },
    );
    ;
  }
}
