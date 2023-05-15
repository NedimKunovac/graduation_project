import 'package:flutter/material.dart';
import 'package:graduation_project/screens/advertisement_details.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.data}) : super(key: key);
  Map? data;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    print('Current user UID - ${FirebaseAuth.instance.currentUser?.uid}');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.data!['postID'])
          .collection('Tasks')
          .where('workers', arrayContainsAny: [
        FirebaseAuth.instance.currentUser?.uid
      ]).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        }

        return Scaffold(
            backgroundColor: Colors.grey,
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, snapshot.data!.docs.length),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView(
                          shrinkWrap:true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return InkWell(
                              onTap: ()=>showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(data['title']),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Text(data['description']),
                                        Text(DateFormat.yMMMMd('en_US')
                                            .format(data['date'].toDate())
                                            .toString()),
                                        Text(data['time']),
                                        Text(data['duration']),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Users')
                                              .where(FieldPath.documentId, whereIn: data['workers'])
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Something went wrong');
                                            }

                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text("Loading");
                                            }

                                            return Expanded(
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                    return SizedBox(
                                                      height: 20,
                                                      child: ListTile(
                                                        title: Text(data['name']),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              child: ListTile(
                                title: Text(data['title']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['description']),
                                    Text(DateFormat.yMMMMd('en_US')
                                        .format(data['date'].toDate())
                                        .toString()),
                                    Text(data['time']),
                                    Text(data['duration']),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildAppBar(BuildContext context, int noTasks) {
    return SliverAppBar(
      expandedHeight: 55,
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 20,
      ),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('View post'),
              value: 'View post',
            ),
            PopupMenuItem(
              child: Text('Leave'),
              value: 'Leave',
            ),
          ],
          onSelected: (value) async{
            if (value == 'View post') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdvertisementDetailed(data: widget.data as Map<String,dynamic>, userType: 2, viewingPost: true)));


            } else if (value == 'Leave') {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Are you sure you want to leave this volunteering opportunity?'),
                  content: Text('If you leave, you can stilll re-apply for this job.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async{
                        var document = await FirebaseFirestore.instance.collection('Posts').doc(widget.data!['postID']).get();

                        var documents = await FirebaseFirestore.instance.collection('Posts').doc(widget.data!['postID']).collection('Tasks').where('workers', arrayContainsAny: [FirebaseAuth.instance.currentUser?.uid]).get();

                        for(int i =0; i<documents.size; i++) {
                          Map<String, dynamic> DocumentData = documents.docs[i].data() as Map<String, dynamic>;
                          List <dynamic> tempList = DocumentData['workers'] ;
                          tempList.remove(FirebaseAuth.instance.currentUser?.uid);
                          print(tempList.toString());

                          try{
                            FirebaseFirestore.instance.collection('Posts').doc(widget.data!['postID']).collection('Tasks').doc(documents.docs[i].id).update({
                              'workers': tempList
                            });
                          }catch(e){
                            print(e.toString());
                          }
                        }

                        print(document['acceptedApplicants']);

                        List<String> myList = List.from(document['acceptedApplicants']);
                        myList.remove(FirebaseAuth.instance.currentUser?.uid);

                        print(myList.toString());

                        try{
                          FirebaseFirestore.instance.collection('Posts').doc(widget.data!['postID']).update({
                            'acceptedApplicants': myList
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }catch(e){
                          print(e.toString());
                        }

                      },
                      child: const Text('Yes',
                      style: TextStyle(
                        color: Colors.red
                      ),),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'No'),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.data!['title']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'You have ${noTasks} task(s) for today!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
