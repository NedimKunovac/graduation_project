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
  ///List of pages for botton navbar
  ///N pages must be equal to n buttons
  final List<Widget> _widgetOptions = <Widget>[];

  ///Bottom navbar logic
  ///Set navbar page to tapped icon
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///Dynamically changes AppBar title based on page that is opened
  AppBarBulder(data) {
    if (_selectedIndex == 1) {
      return Center(
          child: Text('Your messages', style: TextStyle(color: Colors.blue)));
    } else if (_selectedIndex == 2) {
      return Center(
          child: Text('Your profile', style: TextStyle(color: Colors.blue)));
    } else {
      var message='';
      if(data['type']==0 || data['type']==2) message = 'Your currently available volunteering opportunities:';
      else message='Your currently active posts:';

      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Welcome ${data['name']}!',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          SizedBox(
          height: 5,
          ),
          Center(
            child: Text(message,
                style: TextStyle(color: Colors.grey,
                fontSize: 15)),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      );
    }
  }

  ///Adds Floating Action Button logic
  FloatingActionButtonBuilder(data) {
    if (_selectedIndex == 0 && (data['type'] == 0 || data['type'] == 1)) {
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
              content: const Text(
                  'You will be redirected to the post creation page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdvertisementForm(
                                userID: FirebaseAuth.instance.currentUser?.uid,
                                userName: data['name'],
                                userProfilePhoto: data['profilePhotoUrl'],
                              ))),
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
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          _widgetOptions.add(ViewAdvertisements(
              userID: FirebaseAuth.instance.currentUser?.uid,
              userType: data['type']));
          _widgetOptions.add(Placeholder());
          _widgetOptions.add(ProfilePage());

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              backgroundColor: Colors.white,
              elevation: 0,
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              title: AppBarBulder(data),
            ),

            ///Body openes selected page/widget based on list above
            body: Container(child: _widgetOptions.elementAt(_selectedIndex)),

            ///Button that routes to create new advertisement page, doesn't load if volunteer is logged in
            floatingActionButton: FloatingActionButtonBuilder(data),

            ///Bottom navbar, tapped icons set index of page, aka call _onItemTapped()
            bottomNavigationBar: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                )
              ]),
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
                onTap: _onItemTapped,
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Loading'),
          ),
        );
      },
    );
  }
}
