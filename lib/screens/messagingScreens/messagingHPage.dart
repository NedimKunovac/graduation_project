import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/messagingScreens/activeChats.dart';
import 'package:graduation_project/screens/messagingScreens/recentChats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatPage.dart';

class messagingHPage extends StatefulWidget {
  const messagingHPage({Key? key}) : super(key: key);

  @override
  State<messagingHPage> createState() => _messagingHPageState();
}

class _messagingHPageState extends State<messagingHPage> {
  final firestore = FirebaseFirestore.instance;
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('Users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // Access the documents in the query snapshot
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            // Access the fields of the first document
            List<String> _suggestions = [];
            for (int i = 0; i < documents.length; i++) {
              Map<String, dynamic> userData =
                  documents[i].data() as Map<String, dynamic>;
              _suggestions.add(userData['name']);
            }
            var SearchBar =  EasySearchBar(

                elevation: 0,
                appBarHeight: 70,
                backgroundColor: Colors.white,
                title: const Text('Messages'),
                onSearch: (value) {},
                onSuggestionTap: (value) {
                  Navigator.of(context, rootNavigator: true).push(
                    // ensures fullscreen
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        id: documents[_suggestions.indexOf(value)].id,
                      ),
                    ),
                  );
                },
                suggestions: _suggestions,



          );
            // Return a widget that displays the data
            return Scaffold(
              appBar: SearchBar,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    //
                    // Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 15),
                    //     decoration: BoxDecoration(
                    //       color:Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           blurRadius: 10,
                    //           spreadRadius: 2,
                    //           offset: Offset(0, 3),
                    //         )
                    //       ],
                    //     ),
                    //
                    //   ),),
                    ActiveChats(),
                    RecentChats(),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
