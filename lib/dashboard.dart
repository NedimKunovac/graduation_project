import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:graduation_project/profilePage.dart';
import 'viewAdvertisements.dart';
import 'advertisementForm.dart';

///Dashboard, main page of the app
///Make sure hide code for easier view

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, context}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ///Userdata saved for future use
  var userName = '';
  String? userID;
  var userType = 0;

  ///List of pages for botton navbar
  ///N pages must be equal to n buttons
  List<Widget> _widgetOptions = <Widget>[
    /// VIEW ADVERTISEMENTS PAGE
    ViewAdvertisements(),

    ///TODO: VIEW MESSAGES PAGE
    Placeholder(),

    ///TODO: VIEW PROFILE PAGE
    ProfilePage(),
  ];

  static CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  ///Pass all relevant fetched userdata to widgets after load
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      users
          .doc('${FirebaseAuth.instance.currentUser?.uid}')
          .get()
          .then(((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userName = documentSnapshot['name'];
          userID = FirebaseAuth.instance.currentUser?.uid;
          userType = documentSnapshot['type'];
          setState(() {});
        } else {
          print('Document does not exist on the database');
        }
      }));
    });
  }

  ///Bottom navbar logic
  ///Set navbar page to tapped icon
  @override
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///Dynamically changes AppBar title based on page that is opened
  AppBarBulder() {
    if (_selectedIndex == 1) {
      return Text('Messages', style: TextStyle(color: Colors.blue));
    } else if (_selectedIndex == 2) {
      return Text('Profile', style: TextStyle(color: Colors.blue));
    } else {
      return Text(
        'Welcome ${userName}!',
        style: TextStyle(color: Colors.blue),
      );
    }
  }

  ///Adds Floating Action Button logic
  FloatingActionButtonBuilder() {
    if (_selectedIndex == 0 && (userType == 0 || userType == 1)) {
      return FadeIn(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Are you sure you want to add a post?'),
              content: const Text('You will be redirected to the post creation page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdvertisementForm(userID: userID,))),
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'No'),
                  child: const Text('No'),
                ),

              ],
            ),
          ),
        ),
      );
    }
  }

  ///Structure itself
  Widget build(BuildContext context) {
    return Scaffold(
      ///Appbar made to change based on page loaded
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: AppBarBulder(),

          ///BACK BUTTON
          ///TODO: REMOVE THIS BUTTON, ADD LOGOUT TO PROFILE PAGE
          leading: IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Sign out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'No'),
                    child: const Text('No'),
                  ),
                ],
              ),
            ),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          )),

      ///Body openes selected page/widget based on list above
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),

      ///Button that routes to create new advertisement page, doesn't load if volunteer is logged in
      floatingActionButton: FloatingActionButtonBuilder(),

      ///Bottom navbar, tapped icons set index of page, aka call _onItemTapped()
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
            )
          ]
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            ///HOME PAGE ICON
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            ///MESSAGES ICON
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
              backgroundColor: Colors.blue,
            ),
            ///PROFILE ICON
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
           onTap:_onItemTapped,
        ),
      ),
    );
  }
}
