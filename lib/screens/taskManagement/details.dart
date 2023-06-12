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
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, snapshot.data!.docs.length),
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView(
                          shrinkWrap:true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all( color: Colors.blue.shade700),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: InkWell(
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data['title']),
                                            Text(
                                              DateFormat.yMMMMd('en_US')
                                                  .format(data['date'].toDate())
                                                  .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ]),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              Flexible(
                                                child: Text(
                                                  data['description'],
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              )
                                            ]),

                                            //data['description']
                                            SizedBox(height: 10),
                                            Row(children: [
                                              Text(
                                                'Event time:',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                data['time'],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ]),
                                            SizedBox(height: 10),

                                            Row(children: [
                                              Text(
                                                'Event duration:',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                data['duration'],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(data['title']),
                                        Text(
                                          DateFormat.yMMMMd('en_US')
                                              .format(data['date'].toDate())
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(data['description']),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data['duration']),
                                            Text(data['time']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),


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
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 20,
        color: Colors.black,
      ),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert,color: Colors.black),
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
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
